<div id='pt-br'>
<details>
<summary>Versão em Português 🇧🇷 (Clique Aqui)</summary>
    <h1>Guia de Instalação (Arch Linux)</h1>
        <p>Os scripts, arquivos e informações foram criados e editados para uso próprio, mas sinta-se livre para utilizá-los... Recomendo que acesse o <a href="https://wiki.archlinux.org/title/Installation_guide_(Português)">Guia de Instalação Oficial.<a> para desenvolver o seu próprio script 🚀</p>
    <h2>Instalando Arch Linux</h2>
    <h3>Opcional</h3>
        <p>Configurar Horário do Sistema e Layout do Teclado:</p>
        <pre><code>$ timedatectl set-ntp true ;</code></pre>
        <pre><code>$ loadkeys us-acentos ;</code></pre>
    <h3>Particionamento</h3>
        <p>Listar Drivers Disponíveis:</p>
        <pre><code>$ fdisk -l ;</code></pre>
        <p>Particionar um driver específico:</p>
        <pre><code>$ fdisk /dev/nvme0n1 ;</code></pre>
        <p>Recomendações de Formatos de Arquivos e Alocação para cada partição:</p>
        <pre><code><p>p1= +112690M  # Root - Linux filesystem;</p><p>p2= +807M     # Boot - EFI System;</p><p>p3= +16434M   # Swap - Linux Swap;</p><p>p4= [ENTER]   # Home - Linux filesystem;</p></code></pre>
    <h3>Formatação</h3>
        <pre><code><p>$ mkfs.ext4 /dev/nvme0n1p1 ;     # Formata a partição root para ext4;</p><p>$ mkfs.fat -F32 /dev/nvme0n1p2 ; # Formata a partição boot para fat32;</p><p>$ mkswap /dev/nvme0n1p3 ;        # Formata a partição swap para linux-swap;</p><p>$ mkfs.ext4 /dev/nvme0n1p4 ;     # Formata a partição home para ext4;</p></pre></code>
    <h3>Montar os Sistemas de Arquivos</h3>
        <pre><code><p>$ mount /dev/nvme0n1p1 /mnt ;</p><p>$ mkdir /mnt/boot/efi -p ;</p><p>$ mkdir /mnt/home ;</p><p>$ mount /dev/nvme0n1p2 /mnt/boot/efi ;</p><p>$ swapon /dev/nvme0n1p3 ;</p><p>$ mount /dev/nvme0n1p4 /mnt/home ;</p></pre></code>
    <h3>Pacstrap</h3>
        <pre><code>$ pacstrap -K /mnt base base-devel linux linux-firmware linux-firmware-qlogic sof-firmware nano dhcpcd git ;</pre></code>
    <h5>Gerar Arquivo fstab</h5>
        <pre><code>$ genfstab -U /mnt >> /mnt/etc/fstab ;</pre></code>
    <h5>Entrar no sistema com arch-chroot</h5>
        <pre><code>$ arch-chroot /mnt ;</pre></code>
    <h3>Configurando o Sistema</h3>
        <p>Use o arquivo "./install.sh" para configuração scriptada (automática), ou siga o guia de instalação disponível na <a href="https://wiki.archlinux.org/title/Installation_guide_(Português)">Arch Wiki</a>.</p>
    <div>
    <details>
    <summary>Listar todos os pacotes/aplicativos.</summary>
        <h1>Lista de Pacotes e Aplicativos</h1>
        <table>
            <tr>
                <th>Pacote</th>
                <th>Descrição</th>
            </tr>
            <tr>
                <td>archlinux-keyring</td>
                <td>Atualiza o arch linux keyring;</td>
            </tr>
            <tr>
                <td>man-db</td>
                <td>Manual de comandos;</td>
            </tr>
            <tr>
                <td>man-pages</td>
                <td>Manual de comandos;</td>
            </tr>
            <tr>
                <td>dosfstools</td>
                <td>Ferramenta de Formatação de Drivers/Partições;</td>
            </tr>
            <tr>
                <td>os-prober</td>
                <td>Detecta outros sistemas operacionais no BOOT;</td>
            </tr>
            <tr>
                <td>mtools</td>
                <td>Coleção de Utilidades para acessar drivers MS-DOS sem montá-los;</td>
            </tr>
            <tr>
                <td>wpa_supplicant</td>
                <td>Suporte para WPA, WPA2 e WPA3 (IEEE 802;11i);</td>
            </tr>
            <tr>
                <td>wireless_tools</td>
                <td>Ferramentas para manipular conexões wireless;</td>
            </tr>
            <tr>
                <td>dialog</td>
                <td>Caixas de Diálogo para shell script;</td>
            </tr>
            <tr>
                <td>polkit</td>
                <td>Políticas de uso;</td>
            </tr>
            <tr>
                <td>gnome-keyring</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>libsecret</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>libgnome-keyring</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>seahorse</td>
                <td>Gnome keyring GUI;</td>
            </tr>
            <tr>
                <td>network-manager-applet</td>
                <td>Ícone de bandeja para conexão de rede;</td>
            </tr>
            <tr>
                <td>cbatticon</td>
                <td>Ícone de bandeja para bateria de notebook;</td>
            </tr>
            <tr>
                <td>volumeicon</td>
                <td>Ícone de bandeja para controlar o volume;</td>
            </tr>
            <tr>
                <td>xorg</td>
                <td>Servidor de Interface Gráfica;</td>
            </tr>
            <tr>
                <td>mesa</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>lib32-mesa</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>xf86-video-amdgpu</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>vulkan-radeon</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>lib32-vulkan-radeon</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>libva-mesa-driver</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>lib32-libva-mesa-driver</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>mesa-vdpau</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>lib32-mesa-vdpau</td>
                <td>Drivers para Placa de Vídeo;</td>
            </tr>
            <tr>
                <td>udisks2</td>
                <td>Gerenciar dispositivos de armazenamento móvel;</td>
            </tr>
            <tr>
                <td>udiskie</td>
                <td>Montar dispositivos de armazenamento móvel automaticamente;</td>
            </tr>
            <tr>
                <td>ufw</td>
                <td>Firewall;</td>
            </tr>
            <tr>
                <td>zip</td>
                <td>Ferramenta de compressão de Arquivos;</td>
            </tr>
            <tr>
                <td>unzip</td>
                <td>Ferramenta de descompatação de Arquivos;</td>
            </tr>
            <tr>
                <td>wget</td>
                <td>Software para adquirir arquivos via HTTP, HTTPS, FTP and FTPS;</td>
            </tr>
            <tr>
                <td>curl</td>
                <td>Software para adquirir arquivos via usando diversos protocolos;</td>
            </tr>
            <tr>
                <td>lm_sensors</td>
                <td>Sensores;</td>
            </tr>
            <tr>
                <td>i2c-tools</td>
                <td>Utilidades para I2C;</td>
            </tr>
            <tr>
                <td>xdg-utils</td>
                <td>Ferramentas XDG (Mais utilizada para gerenciar tipos de arquivos vs softwares compativeis);</td>
            </tr>
        </table>
        <h2>Áudio</h2>
        <table>
            <tr>
                <th>Pacote</th>
                <th>Descrição</th>
            </tr>
            <tr>
                <td>pulseaudio</td>
                <td>Servidor de Áudio;</td>
            </tr>
            <tr>
                <td>lib32-libpulse</td>
                <td>Servidor de Áudio;</td>
            </tr>
            <tr>
                <td>pulseaudio-alsa</td>
                <td>Servidor de Áudio;</td>
            </tr>
            <tr>
                <td>lib32-alsa-plugins</td>
                <td>Servidor de Áudio;</td>
            </tr>
            <tr>
                <td>pulsemixer</td>
                <td>Mixer de Áudio;</td>
            </tr>
        </table>
        <h2>Gerenciador de Janelas / Ambiente de Desktop</h2>
        <table>
            <tr>
                <th>Pacote</th>
                <th>Descrição</th>
            </tr>
            <tr>
                <td>qtile</td>
                <td>Gerenciador de janela;</td>
            </tr>
            <tr>
                <td>slock</td>
                <td>Bloqueador de Sessão;</td>
            </tr>
            <tr>
                <td>dunst</td>
                <td>Habilita Notificações;</td>
            </tr>
            <tr>
                <td>nitrogen</td>
                <td>Gerenciador de Papéis de Parede;</td>
            </tr>
            <tr>
                <td>gtk-engine-murrine</td>
                <td>Corrige temas GTK 3 mudando apenas a paleta de cores da interface;</td>
            </tr>
            <tr>
                <td>kvantum</td>
                <td>Gerenciador de temas Qt5;</td>
            </tr>
            <tr>
                <td>lxappearance</td>
                <td>Gerenciador de temas GTK;</td>
            </tr>
            <tr>
                <td>arc-gtk-theme</td>
                <td>Tema GTK;</td>
            </tr>
            <tr>
                <td>papirus-icon-theme</td>
                <td>Tema de ícones;</td>
            </tr>
            <tr>
                <td>capitaine-cursors</td>
                <td>Tema de cursores;</td>
            </tr>
            <tr>
                <td>rofi</td>
                <td>Menu de Inicialização de Aplicativos;</td>
            </tr>
            <tr>
                <td>rofi-emoji</td>
                <td>Menu para seleção de Emojis;</td>
            </tr>
            <tr>
                <td>xsel</td>
                <td>Gerenciador de Área de Tranferência;</td>
            </tr>
            <tr>
                <td>python3</td>
                <td>Python;</td>
            </tr>
            <tr>
                <td>python-pip</td>
                <td>Python - PIP Install;</td>
            </tr>
            <tr>
                <td>python-psutil</td>
                <td>Python - Utilidades;</td>
            </tr>
            <tr>
                <td>python-setuptools</td>
                <td>Python - Utilidades;</td>
            </tr>
        </table>
        <h2>Aplicativos</h2>
       <table>
            <tr>
                <th>Pacote</th>
                <th>Descrição</th>
            </tr>
            <tr>
                <td>alacritty</td>
                <td>Emulador de terminal;</td>
            </tr>
            <tr>
                <td>firefox</td>
                <td>Navegador Web;</td>
            </tr>
            <tr>
                <td>chromium</td>
                <td>Navegador Web;</td>
            </tr>
            <tr>
                <td>geckodriver</td>
                <td>Web driver do Firefox;</td>
            </tr>
            <tr>
                <td>virtualbox-host-modules-arch</td>
                <td>Módulos para Virtualbox;</td>
            </tr>
            <tr>
                <td>virtualbox</td>
                <td>Virtualbox;</td>
            </tr>
            <tr>
                <td>piper</td>
                <td>Software para personalizar Mouse;</td>
            </tr>
            <tr>
                <td>steam</td>
                <td>Biblioteca Steam;</td>
            </tr>
            <tr>
                <td>lutris</td>
                <td>Software para instalar jogos fora da steam;</td>
            </tr>
            <tr>
                <td>discord</td>
                <td>Discord;</td>
            </tr>
            <tr>
                <td>ristretto</td>
                <td>Visualizador de Imagens;</td>
            </tr>
            <tr>
                <td>pluma</td>
                <td>Editor de Texto;</td>
            </tr>
            <tr>
                <td>flameshot</td>
                <td>Ferramenta para Captura de Tela;</td>
            </tr>
            <tr>
                <td>thunderbird</td>
                <td>Aplicativo de E-mail;</td>
            </tr>
            <tr>
                <td>qbittorrent</td>
                <td>Aplicativo para baixar Torrents;</td>
            </tr>
            <tr>
                <td>neofetch</td>
                <td>Bloat;</td>
            </tr>
            <tr>
                <td>galculator</td>
                <td>Calculadora;</td>
            </tr>
            <tr>
                <td>cmatrix</td>
                <td>Bloat;</td>
            </tr>
            <tr>
                <td>htop</td>
                <td>Monitoramento do Sistema;</td>
            </tr>
            <tr>
                <td>btop</td>
                <td>Monitoramento do Sistema;</td>
            </tr>
            <tr>
                <td>freerdp</td>
                <td>Ferramenta para conexão remota;</td>
            </tr>
            <tr>
                <td>audacity</td>
                <td>Audacity;</td>
            </tr>
            <tr>
                <td>vlc</td>
                <td>VLC;</td>
            </tr>
            <tr>
                <td>gimp</td>
                <td>Gimp;</td>
            </tr>
            <tr>
                <td>engrampa</td>
                <td>Gerenciador de Arquivos Compactados</td>
            </tr>
            <tr>
                <td>thunar</td>
                <td>Gerenciador de Arquivos;</td>
            </tr>
            <tr>
                <td>gvfs</td>
                <td>Plugin para o Thunar (Gerenciador de Arquivos);</td>
            </tr>
            <tr>
                <td>thunar-archive-plugin</td>
                <td>Thunar Plugin para Gerenciador de Arquivos Compactados;</td>
            </tr>
            <tr>
                <td>ffmpegthumbnailer</td>
                <td>Aplicativo para gerar Thumbnails;</td>
            </tr>
            <tr>
                <td>tumbler</td>
                <td>Aplicativo para gerar Thumbnails;</td>
            </tr>
            <tr>
                <td>gdb</td>
                <td>Depurador;</td>
            </tr>
            <tr>
                <td>parcellite</td>
                <td>Gerenciador de Área de Tranferência;</td>
            </tr>
            <tr>
                <td>shellcheck</td>
                <td>sh linter;</td>
            </tr>
        </table>
        <h2>Fontes</h2>
       <table>
            <tr>
                <th>Pacote</th>
                <th>Descrição</th>
            </tr>
            <tr>
                <td>noto-fonts-emoji</td>
                <td>Emojis;</td>
            </tr>
            <tr>
                <td>lib32-fontconfig</td>
                <td>Corrige fontes da Steam;</td>
            </tr>
            <tr>
                <td>ttf-liberation</td>
                <td>Corrige fontes da Steam;</td>
            </tr>
            <tr>
                <td>wqy-zenhei</td>
                <td>Corrige fontes da Steam;</td>
            </tr>
        </table>
    </div>
    <br/>
</div>
<div id='en'>
<details open >
<summary>English Version 🇺🇸</summary>
    <h1>Installation Guide (Arch Linux)</h1>
        <p>This scripts and infomations were created with the sole intention of my own use... But feel free to use them ! Refer to the <a href="https://wiki.archlinux.org/title/Installation_guide">Offical Installation Guide.<a></p>
    <h2>Installing Arch Linux</h2>
    <h3>Optional</h3>
        <p>Configure System Clock and Keyboard Layout:</p>
        <pre><code>$ timedatectl set-ntp true ;</code></pre>
        <pre><code>$ loadkeys us-acentos ;</code></pre>
    <h3>Partitioning</h3>
        <p>List Available Drivers:</p>
        <pre><code>$ fdisk -l ;</code></pre>
        <p>Partition a specific driver:</p>
        <pre><code>$ fdisk /dev/nvme0n1 ;</code></pre>
        <p>Recomended sizes and format file system for each partition:</p>
        <pre><code><p>p1= +112690M  # Root - Linux filesystem;</p><p>p2= +807M     # Boot - EFI System;</p><p>p3= +16434M   # Swap - Linux Swap;</p><p>p4= [ENTER]   # Home - Linux filesystem;</p></code></pre>
    <h3>Formating</h3>
        <pre><code><p>$ mkfs.ext4 /dev/nvme0n1p1 ;     # Format root driver to ext4;</p><p>$ mkfs.fat -F32 /dev/nvme0n1p2 ; # Format boot driver to fat32;</p><p>$ mkswap /dev/nvme0n1p3 ;        # Format swap driver to linux-swap;</p><p>$ mkfs.ext4 /dev/nvme0n1p4 ;     # Format home driver to ext4;</p></pre></code>
    <h3>Mounting</h3>
        <pre><code><p>$ mount /dev/nvme0n1p1 /mnt ;</p><p>$ mkdir /mnt/boot/efi -p ;</p><p>$ mkdir /mnt/home ;</p><p>$ mount /dev/nvme0n1p2 /mnt/boot/efi ;</p><p>$ swapon /dev/nvme0n1p3 ;</p><p>$ mount /dev/nvme0n1p4 /mnt/home ;</p></pre></code>
    <h3>Pacstrap</h3>
        <pre><code>$ pacstrap -K /mnt base base-devel linux linux-firmware linux-firmware-qlogic sof-firmware nano dhcpcd git</pre></code>
    <h5>Generate fstab File</h5>
        <pre><code>$ genfstab -U /mnt >> /mnt/etc/fstab ;</pre></code>
    <h5>Chroot into the system</h5>
        <pre><code>$ arch-chroot /mnt ;</pre></code>
    <h3>Configuring the System</h3>
        <p>Either use the file "./install" for an automated configuration, or follow the steps in the <a href="https://wiki.archlinux.org/title/Installation_guide">Arch Wiki</a>.</p>
    <div>
    <details>
    <summary>List all packages in the intallation file</summary>
        <h1>Packages List</h1>
        <table>
            <tr>
                <th>Package</th>
                <th>Desc</th>
            </tr>
            <tr>
                <td>archlinux-keyring</td>
                <td>Updates arch linux keyring;</td>
            </tr>
            <tr>
                <td>man-db</td>
                <td>Manual database;</td>
            </tr>
            <tr>
                <td>man-pages</td>
                <td>Manual pages;</td>
            </tr>
            <tr>
                <td>dosfstools</td>
                <td>Patitions/Disk formating tool;</td>
            </tr>
            <tr>
                <td>os-prober</td>
                <td>Detecting other operating systems;</td>
            </tr>
            <tr>
                <td>mtools</td>
                <td>Collection of utilities to access MS-DOS disks without mounting them;</td>
            </tr>
            <tr>
                <td>wpa_supplicant</td>
                <td>Support for WPA, WPA2 and WPA3 (IEEE 802;11i);</td>
            </tr>
            <tr>
                <td>wireless_tools</td>
                <td>Tools allowing to manipulate the wireless extensions;</td>
            </tr>
            <tr>
                <td>dialog</td>
                <td>Dialog boxes from a shell script;</td>
            </tr>
            <tr>
                <td>polkit</td>
                <td>Policy Kit;</td>
            </tr>
            <tr>
                <td>gnome-keyring</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>libsecret</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>libgnome-keyring</td>
                <td>Gnome keyring;</td>
            </tr>
            <tr>
                <td>seahorse</td>
                <td>Gnome keyring GUI;</td>
            </tr>
            <tr>
                <td>network-manager-applet</td>
                <td>System tray icon for networking;</td>
            </tr>
            <tr>
                <td>cbatticon</td>
                <td>System tray icon for laptop battery;</td>
            </tr>
            <tr>
                <td>volumeicon</td>
                <td>System tray icon for volume;</td>
            </tr>
            <tr>
                <td>xorg</td>
                <td>Display Server;</td>
            </tr>
            <tr>
                <td>mesa</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>lib32-mesa</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>xf86-video-amdgpu</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>vulkan-radeon</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>lib32-vulkan-radeon</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>libva-mesa-driver</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>lib32-libva-mesa-driver</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>mesa-vdpau</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>lib32-mesa-vdpau</td>
                <td>GPU driver;</td>
            </tr>
            <tr>
                <td>udisks2</td>
                <td>Manage removable storage devices;</td>
            </tr>
            <tr>
                <td>udiskie</td>
                <td>Auto mount removable sotrage devices;</td>
            </tr>
            <tr>
                <td>ufw</td>
                <td>Firewall;</td>
            </tr>
            <tr>
                <td>zip</td>
                <td>Compression Tool;</td>
            </tr>
            <tr>
                <td>unzip</td>
                <td>Decompression Tool;</td>
            </tr>
            <tr>
                <td>wget</td>
                <td>Software package for retrieving files using HTTP, HTTPS, FTP and FTPS;</td>
            </tr>
            <tr>
                <td>curl</td>
                <td>Software package for retrieving files using various protocols;</td>
            </tr>
            <tr>
                <td>lm_sensors</td>
                <td>Sensors;</td>
            </tr>
            <tr>
                <td>i2c-tools</td>
                <td>I2C Tools;</td>
            </tr>
            <tr>
                <td>xdg-utils</td>
                <td>XDG Utilites (Mostly used for Mime Types);</td>
            </tr>
        </table>
        <h2>Audio</h2>
        <table>
            <tr>
                <th>Package</th>
                <th>Desc</th>
            </tr>
            <tr>
                <td>pulseaudio</td>
                <td>Sound server;</td>
            </tr>
            <tr>
                <td>lib32-libpulse</td>
                <td>Sound server;</td>
            </tr>
            <tr>
                <td>pulseaudio-alsa</td>
                <td>Sound server;</td>
            </tr>
            <tr>
                <td>lib32-alsa-plugins</td>
                <td>Sound server;</td>
            </tr>
            <tr>
                <td>pulsemixer</td>
                <td>Sound mixer;</td>
            </tr>
        </table>
        <h2>Window Manager / Desktop Environment</h2>
        <table>
            <tr>
                <th>Package</th>
                <th>Desc</th>
            </tr>
            <tr>
                <td>qtile</td>
                <td>Window manager;</td>
            </tr>
            <tr>
                <td>slock</td>
                <td>Session lock;</td>
            </tr>
            <tr>
                <td>dunst</td>
                <td>Notifications;</td>
            </tr>
            <tr>
                <td>nitrogen</td>
                <td>Wallpaper manager;</td>
            </tr>
            <tr>
                <td>gtk-engine-murrine</td>
                <td>GTK 3 Fix for themes only changing the UI color palette;</td>
            </tr>
            <tr>
                <td>kvantum</td>
                <td>Qt5 theme engine;</td>
            </tr>
            <tr>
                <td>lxappearance</td>
                <td>GTK theme engine;</td>
            </tr>
            <tr>
                <td>arc-gtk-theme</td>
                <td>GTK theme;</td>
            </tr>
            <tr>
                <td>papirus-icon-theme</td>
                <td>Icon theme;</td>
            </tr>
            <tr>
                <td>capitaine-cursors</td>
                <td>Cursor theme;</td>
            </tr>
            <tr>
                <td>rofi</td>
                <td>Run menu;</td>
            </tr>
            <tr>
                <td>rofi-emoji</td>
                <td>Run menu (For emojies selection);</td>
            </tr>
            <tr>
                <td>xsel</td>
                <td>Clipboard manager;</td>
            </tr>
            <tr>
                <td>python3</td>
                <td>Python;</td>
            </tr>
            <tr>
                <td>python-pip</td>
                <td>Python - PIP Install;</td>
            </tr>
            <tr>
                <td>python-psutil</td>
                <td>Python - Utility;</td>
            </tr>
            <tr>
                <td>python-setuptools</td>
                <td>Python - Utility;</td>
            </tr>
        </table>
        <h2>Applications</h2>
       <table>
            <tr>
                <th>Package</th>
                <th>Desc</th>
            </tr>
            <tr>
                <td>alacritty</td>
                <td>Terminal emulator;</td>
            </tr>
            <tr>
                <td>firefox</td>
                <td>Web Browser;</td>
            </tr>
            <tr>
                <td>chromium</td>
                <td>Web Browser;</td>
            </tr>
            <tr>
                <td>geckodriver</td>
                <td>Firefox Web driver;</td>
            </tr>
            <tr>
                <td>virtualbox-host-modules-arch</td>
                <td>Virtualbox modules;</td>
            </tr>
            <tr>
                <td>virtualbox</td>
                <td>Virtualbox;</td>
            </tr>
            <tr>
                <td>piper</td>
                <td>Mouse Software;</td>
            </tr>
            <tr>
                <td>steam</td>
                <td>Steam Library;</td>
            </tr>
            <tr>
                <td>lutris</td>
                <td>Software to setup non steam games;</td>
            </tr>
            <tr>
                <td>discord</td>
                <td>Discord;</td>
            </tr>
            <tr>
                <td>ristretto</td>
                <td>Image Viewer;</td>
            </tr>
            <tr>
                <td>pluma</td>
                <td>Text Editor;</td>
            </tr>
            <tr>
                <td>flameshot</td>
                <td>Screenshot tool;</td>
            </tr>
            <tr>
                <td>thunderbird</td>
                <td>E-mail client;</td>
            </tr>
            <tr>
                <td>qbittorrent</td>
                <td>Torrent downloader;</td>
            </tr>
            <tr>
                <td>neofetch</td>
                <td>Bloat;</td>
            </tr>
            <tr>
                <td>galculator</td>
                <td>Calculator;</td>
            </tr>
            <tr>
                <td>cmatrix</td>
                <td>Bloat;</td>
            </tr>
            <tr>
                <td>htop</td>
                <td>System Monitor;</td>
            </tr>
            <tr>
                <td>btop</td>
                <td>System Monitor;</td>
            </tr>
            <tr>
                <td>freerdp</td>
                <td>Remote desktop connection tool;</td>
            </tr>
            <tr>
                <td>audacity</td>
                <td>Audacity;</td>
            </tr>
            <tr>
                <td>vlc</td>
                <td>VLC;</td>
            </tr>
            <tr>
                <td>gimp</td>
                <td>Gimp;</td>
            </tr>
            <tr>
                <td>engrampa</td>
                <td>Archive manager</td>
            </tr>
            <tr>
                <td>thunar</td>
                <td>File manager;</td>
            </tr>
            <tr>
                <td>gvfs</td>
                <td>Thunar gnome file system plugin;</td>
            </tr>
            <tr>
                <td>thunar-archive-plugin</td>
                <td>Thunar archive plugin;</td>
            </tr>
            <tr>
                <td>ffmpegthumbnailer</td>
                <td>External program to generate thumbnails;</td>
            </tr>
            <tr>
                <td>tumbler</td>
                <td>External program to generate thumbnails;</td>
            </tr>
            <tr>
                <td>gdb</td>
                <td>Debugger;</td>
            </tr>
            <tr>
                <td>parcellite</td>
                <td>Clipboard Manager;</td>
            </tr>
            <tr>
                <td>shellcheck</td>
                <td>sh linter;</td>
            </tr>
        </table>
        <h2>Fonts</h2>
       <table>
            <tr>
                <th>Package</th>
                <th>Desc</th>
            </tr>
            <tr>
                <td>noto-fonts-emoji</td>
                <td>Emoji fonts;</td>
            </tr>
            <tr>
                <td>lib32-fontconfig</td>
                <td>Fix steam font;</td>
            </tr>
            <tr>
                <td>ttf-liberation</td>
                <td>Fix steam font;</td>
            </tr>
            <tr>
                <td>wqy-zenhei</td>
                <td>Fix steam font;</td>
            </tr>
        </table>
    </div>
</div>
