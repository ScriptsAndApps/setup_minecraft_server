

echo "What is the (sub)domain name you want to use for Dynmap? (Eg. map.yoursite.com)"                                                                                                                   
read ccdomain                                                                                                                                                     
                                                                                                                                                                  
echo "What is the IP address of your Minecraft server and the port Dynmap is running on (Eg. 192.168.1.101:8192)"                                                                                   
read ccip                                                                                                                                                         
                                                                                                                                                                  
echo " server {                                                                                                                                                   
        server_name $ccdomain;                                                                                                                                    
        listen 80;                                                                                                                                                
        listen [::]:80;     

		error_page 502 /500.php;
		error_page 504 /500.php;
		location = /500.php {
					root /var/www/html;
					internal;		
					include snippets/fastcgi-php.conf;
					fastcgi_pass unix:/run/php/php8.1-fpm.sock;
			}
        access_log /var/log/nginx/reverse-access.log;                                                                                                             
        error_log /var/log/nginx/reverse-error.log;                                                                                                               
        location / { 
		
					add_header Expires 'Tue, 03 Jul 2001 06:00:00 GMT';
					add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
					add_header Cache-Control 'post-check=0, pre-check=0';
					add_header Pragma 'no-cache';
					add_header Connection 'close';
					
                    proxy_pass http://$ccip;                                                                                                                      
  }                                                                                                                                                               
} " > /etc/nginx/sites-available/$ccdomain.conf                                                                                                                   
                                                                                                                                                                  
ln -s /etc/nginx/sites-available/$ccdomain.conf /etc/nginx/sites-enabled/$ccdomain.conf                                                                           
                                                                                                                                                                  
certbot --nginx --domains $ccdomain                                                                                                                                     
