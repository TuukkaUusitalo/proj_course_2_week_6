FROM eclipse-temurin:21-jdk

# XQuartz / X11
ENV DISPLAY=host.docker.internal:0
ENV QT_X11_NO_MITSHM=1
ENV _JAVA_AWT_WM_NONREPARENTING=1
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=false -Dprism.order=sw"

# ARM64-yhteensopivat GUI/X11/GL/Ääni + fontit
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      maven wget unzip ca-certificates \
      libgtk-3-0 libx11-6 libxext6 libxrender1 libxtst6 libxi6 libxrandr2 \
      libxinerama1 libxfixes3 libxdamage1 libxcb1 libxcomposite1 \
      libgl1-mesa-dev libgl1-mesa-dri libgl1 \
      libasound2t64 fonts-dejavu-core libfreetype6 libfontconfig1 \
      libgdk-pixbuf-2.0-0 libpango-1.0-0 libpangocairo-1.0-0 \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

# JavaFX SDK 21 (ARM64)
RUN wget https://download2.gluonhq.com/openjfx/21/openjfx-21_linux-aarch64_bin-sdk.zip -O /tmp/openjfx.zip && \
    unzip /tmp/openjfx.zip -d /opt && rm /tmp/openjfx.zip

WORKDIR /app

COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests clean package && ls -l target



RUN mvn -q -DskipTests clean package && \
    cp target/ShoppingCart.jar /app/app.jar && \
    ls -l /app/app.jar


ENTRYPOINT ["java", "--module-path", "/opt/javafx-sdk-21/lib", "--add-modules", "javafx.controls,javafx.fxml", "-jar", "app.jar"]