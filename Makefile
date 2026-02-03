.PHONY: start stop restart delete status logs monit

start:
    @echo "Starting the application with PM2"
    pm2 start "npm run dev" --name ansvue

stop:
    @echo "Stopping the application with PM2"
    pm2 stop ansvue

restart:
    @echo "Restarting the application with PM2"
    pm2 restart ansvue

delete:
    @echo "Deleting the application from PM2"
    pm2 delete ansvue

status:
    @echo "Showing PM2 process status"
    pm2 status ansvue

logs:
    @echo "Showing PM2 logs"
    pm2 logs ansvue

monit:
    @echo "Monitoring PM2 processes"
    pm2 monit

install: 
    @echo "Installing dependencies"
    npm install