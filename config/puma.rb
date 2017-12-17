workers 4
threads 0, 16
port ENV.fetch('PORT') { 3000 }

preload_app!
