# Usa una imagen base de Rocker que ya incluye R y RStudio Server.
# La etiqueta 'latest' a menudo apunta a la versión más reciente y estable.
FROM rocker/rstudio:latest

# Instala dependencias adicionales del sistema operativo.
# Se agrega '|| apt-get update --fix-missing' para mayor robustez en la actualización.
RUN apt-get clean && \
    apt-get update --fix-missing || apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        sudo \
        pandoc \
        libclang-dev \
        libpq-dev \
        libcurl4-gnutls-dev \
        libxml2-dev \
        libssl-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff-dev \
        libjpeg-dev \
        libcairo2-dev \
        libxt-dev \
        ca-certificates \
        wget \
        dirmngr \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo predeterminado para el usuario 'rstudio'.
# Aunque no uses renv para esto, es una buena práctica tener un WORKDIR definido.
WORKDIR /home/rstudio/project

# --- Instalación directa de paquetes R (swirl y swirlify) ---
# Instala los paquetes swirl y swirlify directamente en la librería del sistema R
# Se ejecutan como root (por defecto en el RUN) para que estén disponibles globalmente
# y no se necesiten permisos especiales del usuario rstudio.
# Se usa 'R -e' para ejecutar comandos de R.
RUN R -e "install.packages(c('swirl', 'swirlify'), repos = 'https://cran.rstudio.com/', Ncpus = 4)"
# 'Ncpus = 4' intenta usar 4 núcleos para la instalación, acelerando el proceso.
# --- Fin de la Instalación directa de paquetes R ---

# Copia el resto de tu proyecto al contenedor (si tienes archivos R, scripts, etc.).
# Si tu proyecto R principal no está aquí aún, puedes omitir esta línea por ahora
# o asegúrate de que el directorio actual de tu máquina contiene lo que quieres copiar.
# Por ejemplo, si solo quieres el entorno RStudio con swirl/swirlify y nada más,
# esta línea no es estrictamente necesaria para el arranque inicial.
# COPY . /home/rstudio/project

# Expone el puerto por defecto de RStudio Server (8787).
EXPOSE 8787

# Comando para iniciar RStudio Server cuando el contenedor se ejecute.
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]
