Altere o caminho dos arquivos na configuração de volume no docker-compose.yml

Execute o comando abaixo para inicar o container

```
docker-compose -up -d
```

Para atualizar a imagem , execute os comandos abaixo

```
docker pull gustavoalevato/php7.3-oracle-sqlserver

docker-compose up -d --force-recreate --build
``` 