if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

if(NOT DEFINED SHADY_SERVER_NAME)
    message(FATAL_ERROR "SHADY_SERVER_NAME must be defined!")
endif()

if(NOT DEFINED DXC_SERVER_NAME)
    message(FATAL_ERROR "DXC_SERVER_NAME must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    server {
        listen 80;
        server_name @SHADY_SERVER_NAME@;
   
        proxy_redirect off;

        location ~ {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_pass http://devsh.godbolt.client.shady.windows.x86_64:10241;

            proxy_buffering off;
            client_max_body_size 0;
            proxy_connect_timeout  3600s;
            proxy_read_timeout  3600s;
            proxy_send_timeout  3600s;
            send_timeout  3600s;
        }
    }

    server {
            listen 80;
            server_name @DXC_SERVER_NAME@
            
            proxy_redirect off;

            location ~ {
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";

                proxy_pass http://devsh.godbolt.client.dxc.windows.x86_64:10242;

                proxy_buffering off;
                client_max_body_size 0;
                proxy_connect_timeout  3600s;
                proxy_read_timeout  3600s;
                proxy_send_timeout  3600s;
                send_timeout  3600s;
            }
        }

}
]=]
)

message(STATUS "SERVER_NAME = \"${SERVER_NAME}\"")
message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")