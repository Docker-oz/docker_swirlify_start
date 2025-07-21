# Usa una imagen base de Rocker que ya incluye R y RStudio Server.
# La etiqueta 'latest' a menudo apunta a la versión más reciente y estable.
FROM rocker/rstudio:latest

# Instala dependencias adicionales. Agregamos retries para apt-get.
# Se ha eliminado 'pandoc-citeproc' que causaba el error 'no installation candidate'.
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

# Crea el usuario 'swirlify' y establece su contraseña para acceder a RStudio Server.
# (La imagen base ya tiene un usuario 'rstudio' por defecto, pero creamos el tuyo).
RUN useradd -m swirlify && echo "swirlify:swirlify" | chpasswd

# Establece el directorio de trabajo predeterminado para el usuario 'swirlify'.
WORKDIR /home/swirlify

# Expone el puerto por defecto de RStudio Server (8787).
EXPOSE 8787

# Comando para iniciar RStudio Server cuando el contenedor se ejecute.
# Este es el comando estándar para el RStudio Server preinstalado en la imagen base.
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]