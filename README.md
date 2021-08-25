# AccessPoint-Scripts
Repositório contento scripts para a comunicação dos pontos de acesso (roteadores wireless) com o servidor controlador

### O projeto

Este projeto tem como objetivo possibilitar a implementação de uma rede wireless gerenciável de grande porte ou pequeno porte, que seja compátivel com diversos pontos de acesso e atenda aos seguintes requisítos:

 - Flexibilidade
 - Escalabilidade
 - Baixo custo de implementação

<h2 align="center">Procedimentos para instalação</h2>

<h3 align="left">OpenWrt</h3>

Para que os pontos de acesso (roteadores wireless) consigam se comunicar com o servidor, é necessário alterar o firmware original de fábrica dos dispositivos e instalar o firmware OpenWRT. Para saber se seu dispositivo suporta o firmware, consulte o modelo do equipamento através do site: https://openwrt.org/toh/start

Após verificar a compatibilidade do ponto de acesso com o firmware, realiza a instação seguindo as instruções presentes no site da OpenWRT.

<h3 align="left">Instação dos scripts</h3>

Para instalação, acesso o terminal de seu roteador wireless com OpenWrt instalado e execute os seguintes comandos:

```console
opkg update
opkg install curl
curl -LJO https://raw.githubusercontent.com/davi109/AccessPoint-Scripts/main/install/install.sh; chmod +x install.sh
```

Logo após, execute o arquivo baixado com os seguintes parâmetros:

```console
./install.sh -h 'controller_server' -u 'api_user' -p 'api_password'
```

### Links importantes

- [Servidor Controlador](https://github.com/davi109/AccessPoint-Controller)
- [Interface web do controlador](https://github.com/davi109/AccessPoint-ControllerWebInterface)


