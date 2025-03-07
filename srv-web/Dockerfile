# Use an official PHP 7.4 image with Apache
FROM php:8.1-apache

# Set the working directory
WORKDIR /var/www/html

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
  libpng-dev libjpeg-dev libfreetype6-dev libzip-dev zip && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install gd pdo pdo_mysql

# Enable mod_rewrite (for friendly URLs in MVC)
RUN a2enmod rewrite

# Enable Apache SSL module
RUN a2enmod ssl

# Configure Apache DocumentRoot to point to the application folder
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Copy application files to the container
COPY php-app /var/www/html/php-app

# Copy Apache configuration file for HTTPS
COPY ./srv-web/confs/000-default.conf /etc/apache2/sites-available/000-default.conf

# Change permissions to ensure Apache can access the files
RUN chown -R www-data:www-data /var/www/html

# Clean up temporary and installation files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose port 80 and 443
EXPOSE 80 443

# Start Apache in the foreground
CMD ["apache2-foreground"]