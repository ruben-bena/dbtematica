# DbTematica
 
Para ejecutar en local:
- Arrancar el servidor NodeJS:
```shell
cd server_nodejs
node index.js
```
- Arrancar el cliente Flutter:
```shell
cd client_flutter
flutter create . && flutter run
```

Si el cliente se conecta a un servidor de nuestros proxmox, hay que editar la URI del server en el archivo ```app_config.dart``` dentro del cliente Flutter.