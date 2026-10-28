# K0R1 - inicio compatible con Windows PowerShell 5.1
# Ejecuta este archivo con powershell.exe -NoProfile -ExecutionPolicy Bypass -File "ruta\K0R1.ps1"
Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
Add-Type -AssemblyName PresentationCore -ErrorAction Stop
Add-Type -AssemblyName WindowsBase -ErrorAction Stop
Add-Type -AssemblyName System.Speech -ErrorAction Stop

$ErrorActionPreference = 'SilentlyContinue'

# --- 1. ESTRUCTURA XAML PRINCIPAL (UNIFICADA) ---
# Diseño basado en el sitio público K0R1 AURA JARVIS: hero morado, módulos y tarjetas de funciones.
# Seguridad: los PIN siguen siendo de demostración local. Google usa OAuth + PKCE si configuras el Client ID de tipo Desktop app.
# Para activar Google, crea google-client-id.txt junto a este archivo con SOLO el OAuth Client ID público.
# Seguridad: cliente local, no sustituye autenticación/roles de servidor; no guarda tokens deliberadamente.
# El modo Google de esta build habilita solo navegación FREE; las funciones premium no son un sistema de pago real.
[xml]$xamlMain = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="K0R1 OPTIMIZER // COMMAND CENTER" Height="940" Width="1540" MinHeight="780" MinWidth="1180" WindowStartupLocation="CenterScreen"
        ResizeMode="CanResize" Background="#08080D" Foreground="White" FontFamily="Segoe UI">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="BorderBrush" Value="#6436A8"/>
            <Setter Property="Effect"><Setter.Value><DropShadowEffect Color="#8B5CF6" BlurRadius="10" ShadowDepth="0" Opacity="0.18"/></Setter.Value></Setter>
        </Style>
    </Window.Resources>
    <!-- Estilos basados en Setter retirados para evitar el error de inicialización WPF. -->

    <Grid x:Name="RootGrid">

        <!-- ==================== VISTA 1: REGISTRO ==================== -->
        <Grid x:Name="ViewRegister" Visibility="Visible" Background="#09090B">
            <Border Width="450" Padding="35" Background="#0D0D12" CornerRadius="18" BorderBrush="#27273A" BorderThickness="1.5" HorizontalAlignment="Center" VerticalAlignment="Center">
                <StackPanel>
                    <TextBlock Text="⚡ K0R1 OPTIMIZER" FontSize="22" FontWeight="Black" Foreground="#A855F7" HorizontalAlignment="Center" Margin="0,0,0,4"/>
                    <TextBlock Text="PERFIL LOCAL  •  DEMO" FontSize="14" Foreground="#A1A1AA" HorizontalAlignment="Center" Margin="0,0,0,20"/>
                    
                    <TextBlock Text="Correo de perfil (opcional):" FontSize="12" Foreground="#D1D5DB" Margin="0,0,0,6"/>
                    <TextBox x:Name="TxtEmail" Height="40" Background="#14141B" Foreground="White" BorderBrush="#27273A" BorderThickness="1.5" VerticalContentAlignment="Center" FontSize="13" Padding="10,0"/>
                    
                    <Button x:Name="BtnRegister" Content="CONTINUAR AL ACCESO  →" Height="42" Margin="0,20,0,0" Background="#581C87" Foreground="White" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
                    <Button x:Name="BtnGoogleRegister" Content="G  CONTINUAR CON GOOGLE" Height="42" Margin="0,10,0,0" Background="#15151F" Foreground="#E9D5FF" BorderBrush="#6D28D9" BorderThickness="1" FontWeight="Bold"/>
                    <TextBlock Text="Cada usuario debe usar su propio correo y código." FontSize="11" Foreground="#A1A1AA" HorizontalAlignment="Center" Margin="0,12,0,0"/>
                    <TextBlock Text="K0R1  •  WINDOWS COMMAND CENTER" FontSize="11" Foreground="#6B7280" HorizontalAlignment="Center" Margin="0,18,0,0"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- ==================== VISTA 2: LOGIN CON PIN ==================== -->
        <Grid x:Name="ViewLogin" Visibility="Collapsed" Background="#09090B">
            <Border Width="420" Padding="35" Background="#0D0D12" CornerRadius="18" BorderBrush="#27273A" BorderThickness="1.5" HorizontalAlignment="Center" VerticalAlignment="Center">
                <StackPanel>
                    <TextBlock Text="🔒 ACCESO RESTRINGIDO" FontSize="18" FontWeight="Black" Foreground="#A855F7" HorizontalAlignment="Center" Margin="0,0,0,6"/>
                    <TextBlock Text="Introduce tu código de acceso (modo local de demostración):" FontSize="12" Foreground="#A1A1AA" HorizontalAlignment="Center" Margin="0,0,0,20"/>
                    
                    <PasswordBox x:Name="TxtPin" Height="40" Background="#14141B" Foreground="White" BorderBrush="#27273A" BorderThickness="1.5" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" FontSize="16"/>
                    
                    <Button x:Name="BtnLogin" Content="ENTRAR CON CÓDIGO 🔑" Height="42" Margin="0,20,0,0" Background="#581C87" Foreground="White" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
                    <Button x:Name="BtnGoogleLogin" Content="G  INICIAR CON GOOGLE" Height="42" Margin="0,10,0,0" Background="#15151F" Foreground="#E9D5FF" BorderBrush="#6D28D9" BorderThickness="1" FontWeight="Bold"/>
                    <Button x:Name="BtnBackRegister" Content="← VOLVER" Height="32" Margin="0,8,0,0" Background="Transparent" Foreground="#A1A1AA" BorderThickness="0"/>
                    <TextBlock Text="Google requiere configurar un cliente OAuth para verificar la cuenta." FontSize="10" Foreground="#FBBF24" TextWrapping="Wrap" HorizontalAlignment="Center" Margin="0,12,0,0"/>
                </StackPanel>
            </Border>
        </Grid>

        <!-- ==================== VISTA 3: PANEL PRINCIPAL ==================== -->
        <Grid x:Name="ViewAppMain" Visibility="Collapsed" Background="#08080B">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="260"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- BARRA LATERAL DE NAVEGACIÓN -->
            <Border Background="#0A0811" BorderBrush="#35204F" BorderThickness="0,0,1,0">
                <StackPanel Margin="20">
                    <TextBlock Text="K0R1" FontSize="36" FontWeight="Black" Foreground="#A855F7" Margin="0,0,0,-6"/>
                    <TextBlock Text="AURA OPTIMIZER  /  ULTIMATE" FontSize="11" FontWeight="Bold" Foreground="#A1A1AA" Margin="0,0,0,10"/>
                    <Border Background="#151020" BorderBrush="#5B2D83" BorderThickness="1" CornerRadius="10" Padding="10" Margin="0,0,0,18">
                        <StackPanel Orientation="Horizontal">
                            <Ellipse Width="7" Height="7" Fill="#A855F7" Margin="0,0,8,0" VerticalAlignment="Center"/>
                            <TextBlock Text="JARVIS • ONLINE" FontSize="10" FontWeight="Bold" Foreground="#D8B4FE"/>
                        </StackPanel>
                    </Border>
                    
                    <Border Background="#12121A" CornerRadius="8" Padding="10" Margin="0,0,0,20">
                        <StackPanel>
                            <TextBlock x:Name="LblRoleDisplay" Text="Rango: ---" FontSize="11" FontWeight="Bold" Foreground="#A855F7"/>
                            <TextBlock x:Name="LblEmailDisplay" Text="User: ---" FontSize="10" Foreground="#9CA3AF" TextTrimming="CharacterEllipsis"/>
                        </StackPanel>
                    </Border>

                    <TextBlock Text="GENERAL &amp; IA" FontSize="11" FontWeight="Bold" Foreground="#6B7280" Margin="0,0,0,8"/>
                    <Button x:Name="NavInicio" Content=" 📊 Inicio &amp; Monitor" Height="36" Background="#581C87" Foreground="White" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand" FontWeight="SemiBold"/>
                    <Button x:Name="NavAi" Content=" 🤖 K0R1 JARVIS IA" Height="36" Background="Transparent" Foreground="#C084FC" FontWeight="Bold" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    
                    <TextBlock Text="RENDIMIENTO &amp; TWEAKS" FontSize="11" FontWeight="Bold" Foreground="#6B7280" Margin="0,15,0,8"/>
                    <Button x:Name="NavTweaks" Content=" ⚡ Tweaks PRO &amp; Diseño" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavRed" Content=" 🌐 Zero Lag (Red)" Height="36" Background="Transparent" Foreground="#C084FC" FontWeight="Bold" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavFortnite" Content=" 🎮 Fortnite &amp; GPU" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavHardwareFPS" Content=" 🖥️ Mis componentes / FPS" Height="36" Background="Transparent" Foreground="#C084FC" FontWeight="Bold" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavMega" Content="🚀 Mega Optimización" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavLimpieza" Content=" 🧹 Limpieza SSD" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    
                    <TextBlock Text="AVANZADO &amp; HARDWARE" FontSize="11" FontWeight="Bold" Foreground="#6B7280" Margin="0,15,0,8"/>
                    <Button x:Name="NavStartup" Content=" ⚙️ Gestor de Inicio" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavIso" Content=" 💿 Descarga ISOs" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavDrivers" Content=" 🧩 Drivers recomendados" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavBiosRgb" Content=" 💡 BIOS &amp; Control RGB" Height="36" Background="Transparent" Foreground="#9CA3AF" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavPro" Content=" 🧬 PRO / Pickle-style" Height="36" Background="Transparent" Foreground="#C084FC" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                    <Button x:Name="NavCompra" Content=" 🛒 Comprar / Activar plan" Height="36" Background="#312044" Foreground="#F0ABFC" FontWeight="Bold" BorderThickness="0" HorizontalContentAlignment="Left" Margin="0,3" Padding="12,0" Cursor="Hand"/>
                </StackPanel>
            </Border>

            <!-- VISTAS INTERNAS DEL PANEL -->
            <Grid Grid.Column="1" Margin="30">
                
                <!-- VISTA INICIO: DISEÑO INSPIRADO EN LA WEB K0R1 AURA JARVIS -->
                <ScrollViewer x:Name="ViewInicio" Visibility="Visible" VerticalScrollBarVisibility="Auto">
                  <StackPanel>
                    <Border CornerRadius="18" Padding="24" Margin="0,0,0,20" BorderBrush="#49306D" BorderThickness="1"
                            Background="#100B1C">
                      <Border.Effect><DropShadowEffect Color="#7C3AED" BlurRadius="24" ShadowDepth="0" Opacity="0.22"/></Border.Effect>
                      <Grid>
                        <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
                        <StackPanel Grid.Column="0">
                          <TextBlock Text="NEXT-GEN CONTROL INTERFACE" FontSize="11" FontWeight="Bold" Foreground="#A78BFA" Margin="0,0,0,8"/>
                          <TextBlock Text="K0R1 AURA JARVIS" FontSize="31" FontWeight="Black" Foreground="#F5F3FF"/>
                          <TextBlock Text="Controla tu sistema. Entra en modo AURA." FontSize="19" FontWeight="SemiBold" Foreground="#C4B5FD" Margin="0,2,0,8"/>
                          <TextBlock Text="Herramientas de diagnóstico, utilidades de Windows y preparación gaming en un solo panel." FontSize="13" Foreground="#A1A1AA" TextWrapping="Wrap" MaxWidth="720"/>
                          <WrapPanel Margin="0,16,0,0">
                            <Button x:Name="BtnWebFeatures" Content="EXPLORAR FUNCIONES ↗" Background="#6D28D9" Padding="14,9" Margin="0,0,10,0"/>
                            <Button x:Name="BtnOpenWebsite" Content="ABRIR SITIO K0R1 ↗" Background="#21162F" Foreground="#E9D5FF" Padding="14,9"/>
                          </WrapPanel>
                        </StackPanel>
                        <Border Grid.Column="1" Width="112" Height="112" CornerRadius="20" Background="#211238" BorderBrush="#7C3AED" BorderThickness="1" Margin="20,0,0,0" VerticalAlignment="Center">
                          <TextBlock Text="K0R1" FontSize="30" FontWeight="Black" Foreground="#C084FC" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                      </Grid>
                    </Border>

                    <TextBlock Text="MÓDULOS DEL SISTEMA" FontSize="11" FontWeight="Bold" Foreground="#A78BFA" Margin="0,0,0,5"/>
                    <TextBlock Text="Herramientas con propósito" FontSize="25" FontWeight="Black" Foreground="White"/>
                    <TextBlock Text="Diagnóstico claro, acciones revisables y accesos directos. Sin promesas falsas de FPS." FontSize="13" Foreground="#9CA3AF" Margin="0,4,0,16"/>
                    <WrapPanel Margin="0,0,0,8">
                      <Border Width="210" MinHeight="112" Background="#0D0D14" CornerRadius="12" BorderBrush="#34234B" BorderThickness="1" Margin="0,0,12,12" Padding="14">
                        <StackPanel><TextBlock Text="◈  ALMACENAMIENTO" FontWeight="Bold" Foreground="#C4B5FD"/><TextBlock Text="Espacio libre, unidades y limpieza revisable." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,8,0,0"/></StackPanel>
                      </Border>
                      <Border Width="210" MinHeight="112" Background="#0D0D14" CornerRadius="12" BorderBrush="#34234B" BorderThickness="1" Margin="0,0,12,12" Padding="14">
                        <StackPanel><TextBlock Text="⌁  PROCESOS Y ARRANQUE" FontWeight="Bold" Foreground="#C4B5FD"/><TextBlock Text="Revisa procesos y programas de inicio antes de cambiar nada." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,8,0,0"/></StackPanel>
                      </Border>
                      <Border Width="210" MinHeight="112" Background="#0D0D14" CornerRadius="12" BorderBrush="#34234B" BorderThickness="1" Margin="0,0,12,12" Padding="14">
                        <StackPanel><TextBlock Text="⌘  DIAGNÓSTICO DNS" FontWeight="Bold" Foreground="#C4B5FD"/><TextBlock Text="Comprueba conectividad y resolución de nombres." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,8,0,0"/></StackPanel>
                      </Border>
                      <Border Width="210" MinHeight="112" Background="#0D0D14" CornerRadius="12" BorderBrush="#34234B" BorderThickness="1" Margin="0,0,12,12" Padding="14">
                        <StackPanel><TextBlock Text="✧  ENFOQUE GAMING" FontWeight="Bold" Foreground="#C4B5FD"/><TextBlock Text="Revisa el equipo y prepara Windows antes de jugar." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,8,0,0"/></StackPanel>
                      </Border>
                    </WrapPanel>
                    <TextBlock Text="RENDIMIENTO DEL SISTEMA  •  ESTADO DEL EQUIPO  •  HERRAMIENTAS" FontSize="13" Foreground="#9CA3AF" Margin="0,4,0,16"/>

                    <WrapPanel>
                        <Border Width="230" Height="120" Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Margin="0,0,20,20" Padding="16">
                            <StackPanel>
                                <TextBlock Text="CPU  /  USO DEL PROCESADOR" FontSize="11" FontWeight="Bold" Foreground="#6B7280"/>
                                <TextBlock x:Name="LblCpuVal" Text="N/D" FontSize="30" FontWeight="Black" Foreground="#A855F7" Margin="0,2,0,0" ToolTip="Porcentaje de uso del procesador, si Windows lo informa."/>
                                <ProgressBar x:Name="BarCpu" Height="10" Value="0" Maximum="100" Background="#1E1E2C" Foreground="#A855F7" BorderThickness="0" Margin="0,6,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Width="230" Height="120" Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Margin="0,0,20,20" Padding="16">
                            <StackPanel>
                                <TextBlock Text="GPU  /  USO GRÁFICO" FontSize="11" FontWeight="Bold" Foreground="#6B7280"/>
                                <TextBlock x:Name="LblGpuVal" Text="N/D" FontSize="30" FontWeight="Black" Foreground="#A855F7" Margin="0,2,0,0" ToolTip="No se inventa el porcentaje si Windows no expone un contador compatible."/>
                                <ProgressBar x:Name="BarGpu" Height="10" Value="0" Maximum="100" Background="#1E1E2C" Foreground="#A855F7" BorderThickness="0" Margin="0,6,0,0"/>
                                <TextBlock x:Name="LblTempVal" Text="Temperatura: N/D" FontSize="12" Foreground="#A1A1AA" Margin="0,8,0,0" ToolTip="Windows no expone temperaturas fiables en todos los equipos; N/D significa que no hay sensor compatible."/>
                            </StackPanel>
                        </Border>
                        <Border Width="230" Height="120" Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Margin="0,0,20,20" Padding="16">
                            <StackPanel>
                                <TextBlock Text="MEMORIA  /  RAM EN USO" FontSize="11" FontWeight="Bold" Foreground="#6B7280"/>
                                <TextBlock x:Name="LblRamVal" Text="N/D" FontSize="30" FontWeight="Black" Foreground="#A855F7" Margin="0,2,0,0" ToolTip="Porcentaje de memoria física en uso."/>
                                <ProgressBar x:Name="BarRam" Height="10" Value="0" Maximum="100" Background="#1E1E2C" Foreground="#A855F7" BorderThickness="0" Margin="0,6,0,0"/>
                            </StackPanel>
                        </Border>
                    </WrapPanel>

                    <Border Background="#0D0D14" CornerRadius="14" BorderBrush="#581C87" BorderThickness="1.5" Padding="22" Margin="0,10,0,0">
                        <StackPanel>
                            <TextBlock Text="🛠️ BOTÓN MAESTRO + BACKUP AUTOMÁTICO" FontWeight="Bold" Foreground="#C084FC" FontSize="15" Margin="0,0,0,4"/>
                            <TextBlock Text="Crea un respaldo de ajustes de usuario y activa Modo Juego/captura en segundo plano de forma reversible. No promete FPS extra." FontSize="12" Foreground="#9CA3AF" TextWrapping="Wrap" Margin="0,0,0,15"/>
                            <Button x:Name="BtnMasterAll" Content="OPTIMIZAR WINDOWS + CREAR RESPALDO" Height="45" Background="#581C87" Foreground="White" FontWeight="Bold" FontSize="13" BorderThickness="0" Cursor="Hand"/>
                            <Button x:Name="BtnSystemReport" Content="GENERAR INFORME DEL SISTEMA" Height="38" Margin="0,10,0,0" Background="#1E1E2C" Foreground="#C084FC" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
                            <Button x:Name="BtnRestoreBackup" Content="RESTAURAR BACKUP DEL REGISTRO" Height="38" Margin="0,8,0,0" Background="#27272A" Foreground="White" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
                        </StackPanel>
                    </Border>
                  </StackPanel>
                </ScrollViewer>
                <!-- VISTA TWEAKS -->
                <ScrollViewer x:Name="ViewTweaks" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel>
                        <TextBlock Text="Centro de Control de Tweaks" FontSize="26" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Panel PRO: cambios reversibles para Windows 11 y juego competitivo. Cada acción indica qué modifica; evita promesas falsas de FPS." FontSize="13" Foreground="#9CA3AF" Margin="0,4,0,20"/>

                        <Border Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Padding="18" Margin="0,0,0,12" Width="850" HorizontalAlignment="Left">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0" Margin="0,0,15,0">
                                    <TextBlock Text="⚡ Win32 Priority Separation" FontSize="15" FontWeight="Bold" Foreground="White"/>
                                    <TextBlock Text="Ajusta un valor de planificación de Windows. El efecto depende del sistema y no garantiza más FPS." FontSize="12" Foreground="#9CA3AF" TextWrapping="Wrap" Margin="0,3,0,0"/>
                                </StackPanel>
                                <ToggleButton x:Name="TglTweak1" Grid.Column="1" IsEnabled="False" ToolTip="Usa el botón maestro para el ajuste con respaldo."/>
                            </Grid>
                        </Border>

                        <Border Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Padding="18" Margin="0,0,0,12" Width="850" HorizontalAlignment="Left">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                <StackPanel Grid.Column="0" Margin="0,0,15,0">
                                    <TextBlock Text="🛡️ Desactivar Telemetría" FontSize="15" FontWeight="Bold" Foreground="White"/>
                                    <TextBlock Text="Este interruptor es informativo: no desactiva servicios ni modifica la privacidad de Windows todavía." FontSize="12" Foreground="#9CA3AF" TextWrapping="Wrap" Margin="0,3,0,0"/>
                                </StackPanel>
                                <ToggleButton x:Name="TglTweak2" Grid.Column="1" IsEnabled="False" ToolTip="Desactivado hasta implementar una opción reversible y comprobada."/>
                            </Grid>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="📊 CÓMO LEER LAS MÉTRICAS" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="CPU % = carga reportada por Windows; RAM % = memoria usada respecto a la utilizable; GPU % depende de los contadores que exponga el driver; disco y red pueden variar por muestreo. Son lecturas del sistema, no una promesa de FPS. Para medir FPS/1% lows usa el contador de Fortnite o una herramienta de confianza y compara la misma escena." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🎮 AJUSTES COMPETITIVOS DE FORTNITE" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Empieza por modo Rendimiento si resulta estable, pantalla completa, V-Sync desactivado si priorizas latencia, límite de FPS que el equipo mantenga y resolución 3D que conserve claridad. Cambia una opción a la vez y mide FPS medios, 1% lows y latencia; no hay porcentaje universal de mejora." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🧩 INICIO DE WINDOWS" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Revisa Aplicaciones de inicio en Configuración o Administrador de tareas y desactiva solo programas que reconozcas y no necesites al arrancar. No deshabilites servicios de AMD, audio, red, seguridad ni controladores a ciegas." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,0"/>
                                <Button x:Name="BtnOpenStartupSettings" Content="ABRIR APLICACIONES DE INICIO" HorizontalAlignment="Left" Padding="14,9" Margin="0,10,0,0" Background="#202030" Foreground="White"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🛡️ SEGURIDAD DEL SISTEMA" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="K0R1 no desactiva Microsoft Defender, Firewall ni UAC. Mantén Windows y drivers actualizados, descarga solo desde fuentes oficiales y no ejecutes el optimizador como administrador salvo que una función concreta lo requiera y entiendas el cambio." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,0"/>
                                <Button x:Name="BtnOpenWindowsSecurity" Content="ABRIR SEGURIDAD DE WINDOWS" HorizontalAlignment="Left" Padding="14,9" Margin="0,10,0,0" Background="#202030" Foreground="White"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="💡 RGB DE VENTILADORES" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="El cambio físico depende del controlador, conexión y compatibilidad. Esta versión puede abrir OpenRGB si está instalado; no garantiza compatibilidad con cada placa, hub o ventilador. Si no lo detecta, usa la utilidad oficial del fabricante." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🎮 WINDOWS GAME MODE" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Activa el modo de juego de Windows para priorizar la experiencia al jugar. No garantiza más FPS; requiere volver a iniciar el juego en algunos casos." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnEnableGameMode" Content="ACTIVAR GAME MODE" Padding="14,9" Margin="0,0,10,8" Background="#581C87" Foreground="White"/>
                                    <Button x:Name="BtnOpenGameSettings" Content="ABRIR AJUSTES DE JUEGO" Padding="14,9" Margin="0,0,10,8" Background="#202030" Foreground="White"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblGameModeStatus" Text="Game Mode: sin consultar." Foreground="#D1D5DB" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="📹 CAPTURA EN SEGUNDO PLANO" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Desactiva la grabación en segundo plano de Game DVR para evitar captura no deseada y posible uso extra de recursos. Puedes volver a activarla desde aquí." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnDisableCapture" Content="DESACTIVAR CAPTURA" Padding="14,9" Margin="0,0,10,8" Background="#581C87" Foreground="White"/>
                                    <Button x:Name="BtnRestoreCapture" Content="REACTIVAR CAPTURA" Padding="14,9" Margin="0,0,10,8" Background="#202030" Foreground="White"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblCaptureStatus" Text="Captura: sin modificar." Foreground="#D1D5DB" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="⚡ PERFIL DE ENERGÍA" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Usa Alto rendimiento cuando juegues conectado a la corriente y vuelve a Equilibrado para uso diario. En algunos equipos el cambio aumenta consumo y temperatura." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnTweakHighPower" Content="ALTO RENDIMIENTO" Padding="14,9" Margin="0,0,10,8" Background="#14532D" Foreground="White"/>
                                    <Button x:Name="BtnTweakBalancedPower" Content="VOLVER A EQUILIBRADO" Padding="14,9" Margin="0,0,10,8" Background="#202030" Foreground="White"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblTweakPowerStatus" Text="Energía: sin consultar." Foreground="#D1D5DB" TextWrapping="Wrap"/>
                            </StackPanel>
                        </Border>

                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="💾 ALMACENAMIENTO Y ESPACIO LIBRE" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Consulta espacio libre y estado básico de las unidades sin borrar archivos. Si el disco está casi lleno, libera espacio con Limpieza SSD y revisa tus archivos personalmente." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <Button x:Name="BtnStorageHealth" Content="ANALIZAR UNIDADES" HorizontalAlignment="Left" Padding="14,9" Background="#581C87" Foreground="White"/>
                                <TextBlock x:Name="LblStorageHealth" Text="Pulsa para revisar discos y espacio libre." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,10,0,0"/>
                            </StackPanel>
                        </Border>

                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="📊 PROCESOS QUE MÁS RECURSOS USAN" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Muestra procesos con mayor consumo de memoria y CPU para que identifiques aplicaciones que tú reconoces. No cierra procesos automáticamente." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <Button x:Name="BtnProcessReport" Content="REVISAR PROCESOS" HorizontalAlignment="Left" Padding="14,9" Background="#581C87" Foreground="White"/>
                                <TextBlock x:Name="LblProcessReport" Text="Sin analizar." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,10,0,0"/>
                            </StackPanel>
                        </Border>

                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🚀 APLICACIONES DE INICIO" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Lista entradas de inicio comunes del usuario y del equipo para ayudarte a detectar programas que no necesitas al encender. No desactiva nada automáticamente." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <Button x:Name="BtnStartupReport" Content="ANALIZAR INICIO" HorizontalAlignment="Left" Padding="14,9" Background="#581C87" Foreground="White"/>
                                <TextBlock x:Name="LblStartupReport" Text="Pulsa para listar aplicaciones de inicio." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,10,0,0"/>
                            </StackPanel>
                        </Border>

                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🌐 DNS Y CONECTIVIDAD" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Comprueba resolución DNS y permite vaciar la caché DNS de Windows si hay problemas de nombres de dominio. No reduce por sí solo el ping de Fortnite." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnDnsTest" Content="PROBAR DNS" Padding="14,9" Margin="0,0,10,8" Background="#581C87" Foreground="White"/>
                                    <Button x:Name="BtnDnsFlush" Content="VACIAR CACHÉ DNS" Padding="14,9" Margin="0,0,10,8" Background="#202030" Foreground="White"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblDnsStatus" Text="Sin prueba DNS." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Border>

                        <Border Background="#11101A" CornerRadius="14" BorderBrush="#3B1D56" BorderThickness="1" Padding="18" Margin="0,0,0,12" MaxWidth="850" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="🖥️ GPU PREFERIDA PARA FORTNITE" FontSize="16" FontWeight="Bold" Foreground="#D8B4FE"/>
                                <TextBlock Text="Abre la página de gráficos de Windows para elegir Alto rendimiento para Fortnite si tu equipo tiene más de una GPU. Windows puede requerir que selecciones el ejecutable del juego." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,12"/>
                                <Button x:Name="BtnOpenGraphicsSettings" Content="ABRIR AJUSTES DE GRÁFICOS" HorizontalAlignment="Left" Padding="14,9" Background="#581C87" Foreground="White"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>

                <!-- VISTA JARVIS IA / AURA LOCAL -->
                <StackPanel x:Name="ViewAi" Visibility="Collapsed">
                    <TextBlock Text="✦ K0R1 AURA  /  JARVIS INTELLIGENCE" FontSize="27" FontWeight="Black" Foreground="#E9D5FF"/>
                    <TextBlock Text="Asistente local sin API ni claves. Puede revisar los componentes detectados, estimar FPS orientativos y recomendar ajustes seguros." FontSize="13" Foreground="#C4B5FD" TextWrapping="Wrap" Margin="0,5,0,16"/>
                    <Border MaxWidth="920" Height="450" Background="#0D0B16" CornerRadius="18" BorderBrush="#8B5CF6" BorderThickness="1.5" Padding="18" HorizontalAlignment="Left">
                        <Border.Effect><DropShadowEffect Color="#7C3AED" BlurRadius="24" ShadowDepth="0" Opacity="0.35"/></Border.Effect>
                        <Grid>
                            <Grid.RowDefinitions><RowDefinition Height="*"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
                            <TextBox x:Name="TxtAiChat" Grid.Row="0" Background="#100D1B" Foreground="#F3E8FF" BorderBrush="#4C1D95" FontSize="14" IsReadOnly="True" AcceptsReturn="True" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Padding="14" Text="K0R1 OPTIMIZER // JARVIS`nESTADO: AURA lista • sin API key • motor local con modo inteligente de respaldo`n`nPrueba: ¿cuántos FPS puedo sacar?, analiza mis componentes, recomienda tweaks o ¿cómo mejoro Fortnite?`n`n"/>
                            <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,12,0,0">
                                <TextBox x:Name="TxtAiInput" Width="500" Height="42" Background="#12101D" Foreground="White" BorderBrush="#7C3AED" VerticalContentAlignment="Center" FontSize="14" Padding="12,0" ToolTip="Pregunta sobre FPS, hardware, Fortnite o ajustes seguros"/>
                                <Button x:Name="BtnAiSend" Content="ANALIZAR ✦" Width="120" Height="42" Margin="12,0,0,0" Background="#6D28D9" Foreground="White" FontWeight="Bold" BorderThickness="0"/>
                                <Button x:Name="BtnAiSpeak" Content="🔊 HABLAR" Width="115" Height="42" Margin="10,0,0,0" Background="#25133D" Foreground="#E9D5FF" FontWeight="Bold" BorderThickness="0"/>
                            </StackPanel>
                            <TextBlock x:Name="LblAiStatus" Grid.Row="2" Text="● AURA ACTIVA · IA local; Ollama opcional para respuestas generativas" Foreground="#C4B5FD" FontSize="12" Margin="2,12,0,0"/>
                        </Grid>
                    </Border>
                    <TextBlock Text="ATAJOS: escribe FPS, mis componentes, tweaks, Fortnite u optimizar. Los FPS son estimaciones, no mediciones." Foreground="#A78BFA" FontSize="12" Margin="0,12,0,0"/>
                </StackPanel>

                <!-- VISTA CONTROL RGB -->
                <ScrollViewer x:Name="ViewBiosRgb" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel>
                        <TextBlock Text="Control RGB de Hardware" FontSize="26" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Selecciona un perfil visual. El cambio físico requiere software compatible con tu controlador RGB." FontSize="13" Foreground="#9CA3AF" Margin="0,4,0,20"/>

                        <Border Width="600" Background="#0D0D14" CornerRadius="14" BorderBrush="#1E1E2C" BorderThickness="1" Padding="20" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="💡 PERFIL RGB  /  SELECCIÓN" FontWeight="Bold" FontSize="15" Foreground="#C084FC" Margin="0,0,0,10"/>
                                <ComboBox x:Name="CmbRgbColors" Height="40" Background="#12121A" Foreground="White" FontSize="13" Margin="0,0,0,15">
                                    <ComboBoxItem Content="🟣 Morado K0R1 (#581C87)" IsSelected="True"/>
                                    <ComboBoxItem Content="🔵 Azul Eléctrico (#0000FF)"/>
                                    <ComboBoxItem Content="🔴 Rojo Carmesí (#FF0000)"/>
                                    <ComboBoxItem Content="🟢 Verde Neón (#00FF00)"/>
                                    <ComboBoxItem Content="🟡 Amarillo Brillante (#FFFF00)"/>
                                    <ComboBoxItem Content="🌈 Ciclo RGB Automático (Rainbow)"/>
                                </ComboBox>
                                <Button x:Name="BtnApplyRgb" Content="APLICAR CAMBIO DE COLOR RGB" Height="42" Background="#581C87" Foreground="White" FontWeight="Bold" BorderThickness="0" Cursor="Hand"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>

                <!-- VISTAS SECUNDARIAS: HERRAMIENTAS REALES -->
                <ScrollViewer x:Name="ViewStartup" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel>
                        <TextBlock Text="GESTOR DE INICIO" FontSize="28" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Revisa las aplicaciones que se ejecutan al iniciar Windows." Foreground="#A1A1AA" Margin="0,6,0,22"/>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="760" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="Inicio de Windows" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="K0R1 abrirá el Administrador de tareas para que puedas activar o desactivar programas de inicio de forma segura." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,16"/>
                                <Button x:Name="BtnOpenStartup" Content="ABRIR ADMINISTRADOR DE TAREAS" HorizontalAlignment="Left" Background="#581C87"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>
                <StackPanel x:Name="ViewRed" Visibility="Collapsed">
                    <TextBlock Text="ZERO LAG  /  RED" FontSize="28" FontWeight="Black" Foreground="White"/>
                    <TextBlock Text="Diagnóstico de conectividad y descubrimiento básico de dispositivos de tu LAN. No escanea redes externas ni cambia configuraciones." Foreground="#A1A1AA" Margin="0,6,0,22"/>
                    <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="760" HorizontalAlignment="Left">
                        <StackPanel>
                            <TextBlock Text="Prueba de conexión" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                            <TextBlock Text="Comprueba la respuesta de un servidor público. El resultado depende de tu proveedor, Wi-Fi y ruta de conexión." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,16"/>
                            <Button x:Name="BtnNetworkTest" Content="EJECUTAR DIAGNÓSTICO DE INTERNET" HorizontalAlignment="Left" Background="#581C87" Padding="12,8"/>
                            <Button x:Name="BtnLanScan" Content="BUSCAR EQUIPOS EN MI RED LOCAL" HorizontalAlignment="Left" Background="#1E1B2E" Foreground="#E9D5FF" Padding="12,8" Margin="0,10,0,0"/>
                            <TextBlock Text="Busca solo dispositivos de tu red local (LAN). Los equipos que bloquean ping pueden no aparecer." FontSize="11" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,8,0,0"/>
                            <TextBlock x:Name="LblNetworkResult" Text="Listo para probar." Foreground="#E9D5FF" TextWrapping="Wrap" Margin="0,16,0,0"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
                <ScrollViewer x:Name="ViewHardwareFPS" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,8,20">
                        <TextBlock Text="MI PC  /  COMPONENTES Y FPS ESTIMADOS" FontSize="27" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Detecta el hardware real y ofrece una estimación orientativa para Fortnite. Los FPS reales dependen de la GPU, RAM, temperaturas, mapa, partida y ajustes." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,6,0,18"/>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="20" MaxWidth="900" HorizontalAlignment="Left" Margin="0,0,0,12">
                            <StackPanel>
                                <TextBlock Text="01 / COMPONENTES DETECTADOS" FontSize="17" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock x:Name="LblHardwareCPU" Text="CPU: pendiente de detectar" Foreground="#E5E7EB" TextWrapping="Wrap" Margin="0,12,0,4"/>
                                <TextBlock x:Name="LblHardwareGPU" Text="GPU: pendiente de detectar" Foreground="#E5E7EB" TextWrapping="Wrap" Margin="0,4"/>
                                <TextBlock x:Name="LblHardwareRAM" Text="RAM: pendiente de detectar" Foreground="#E5E7EB" TextWrapping="Wrap" Margin="0,4"/>
                                <TextBlock x:Name="LblHardwareWindows" Text="Windows: pendiente de detectar" Foreground="#E5E7EB" TextWrapping="Wrap" Margin="0,4,0,14"/>
                                <Button x:Name="BtnDetectHardwareFPS" Content="DETECTAR MI PC Y ESTIMAR FPS" Padding="14,10" HorizontalAlignment="Left" Background="#581C87" Foreground="White" FontWeight="Bold"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="20" MaxWidth="900" HorizontalAlignment="Left" Margin="0,0,0,12">
                            <StackPanel>
                                <TextBlock Text="02 / FPS ORIENTATIVOS EN FORTNITE" FontSize="17" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock x:Name="LblHardwareFPS" Text="Pulsa detectar para ver una estimación según la GPU encontrada." Foreground="#E5E7EB" TextWrapping="Wrap" Margin="0,12,0,8" FontSize="15"/>
                                <TextBlock Text="Referencia: 1720×1080, modo Rendimiento y ajustes competitivos bajos. No es una medición ni una garantía; en peleas, zonas concurridas y finales de partida los FPS pueden bajar." Foreground="#FBBF24" TextWrapping="Wrap" Margin="0,4,0,0"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>

                <ScrollViewer x:Name="ViewFortnite" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,8,20">
                        <TextBlock Text="FORTNITE  /  COMPETITIVE PERFORMANCE" FontSize="28" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Ryzen 5 5500 • Windows 11 • Perfil de rendimiento reversible. No se prometen FPS mágicos." Foreground="#A1A1AA" Margin="0,6,0,18"/>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="20" MaxWidth="900" HorizontalAlignment="Left" Margin="0,0,0,12">
                            <StackPanel>
                                <TextBlock Text="01  /  JUEGO Y ARCHIVOS DE CONFIGURACIÓN" FontSize="17" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="Detecta Fortnite, localiza GameUserSettings.ini y crea una copia antes de tocar configuraciones. No se borrarán archivos del juego." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,14"/>
                                <WrapPanel>
                                    <Button x:Name="BtnFortnitePriority" Content="PRIORIDAD ALTA (JUEGO ABIERTO)" Margin="0,0,10,8" Padding="14,9" Background="#581C87"/>
                                    <Button x:Name="BtnFortniteFiles" Content="DETECTAR ARCHIVOS + RESPALDO" Margin="0,0,10,8" Padding="14,9" Background="#202030" Foreground="White"/>
                                    <Button x:Name="BtnFortniteOpenConfig" Content="ABRIR CARPETA CONFIG" Margin="0,0,10,8" Padding="14,9" Background="#202030" Foreground="White"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblFortniteFiles" Text="Estado: esperando diagnóstico." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,8,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="20" MaxWidth="900" HorizontalAlignment="Left" Margin="0,0,0,12">
                            <StackPanel>
                                <TextBlock Text="02  /  PLAN DE ENERGÍA PERSONALIZADO" FontSize="17" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="Para jugar conectado a la corriente: activa Alto rendimiento si Windows lo ofrece. En portátil consume más batería y puede aumentar temperatura/ruido. Se puede revertir desde Opciones de energía." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,14"/>
                                <WrapPanel>
                                    <Button x:Name="BtnPowerPlan" Content="ACTIVAR ALTO RENDIMIENTO" Padding="14,9" Background="#14532D" Foreground="White" Margin="0,0,10,8"/>
                                    <Button x:Name="BtnPowerStatus" Content="VER PLAN ACTUAL" Padding="14,9" Background="#202030" Foreground="White" Margin="0,0,10,8"/>
                                </WrapPanel>
                                <TextBlock x:Name="LblPowerStatus" Text="Plan de energía: sin consultar." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,8,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="20" MaxWidth="900" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="03  /  PERFIL COMPETITIVO RECOMENDADO" FontSize="17" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="Empieza con pantalla completa, V-Sync desactivado, límite de FPS estable acorde a tu monitor, sombras bajas/desactivadas y modo de renderizado que funcione mejor en tu equipo. Actualiza AMD Adrenalin desde la web oficial. K0R1 no desactiva Defender ni elimina archivos de Fortnite." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,0"/>
                            </StackPanel>
                        </Border>
                    </StackPanel>
                </ScrollViewer>
                <StackPanel x:Name="ViewMega" Visibility="Collapsed">
                    <TextBlock Text="MEGA OPTIMIZACIÓN" FontSize="28" FontWeight="Black" Foreground="White"/>
                    <TextBlock Text="Acciones controladas, con confirmación antes de modificar el sistema." Foreground="#A1A1AA" Margin="0,6,0,22"/>
                    <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="760" HorizontalAlignment="Left">
                        <StackPanel>
                            <TextBlock Text="Punto de restauración y respaldo" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                            <TextBlock Text="Antes de tocar el Registro, crea un respaldo. La disponibilidad de puntos de restauración depende de la configuración de Windows." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,16"/>
                            <Button x:Name="BtnCreateBackup" Content="RESPALDAR CLAVE DE PRIORIDAD" HorizontalAlignment="Left" Background="#581C87"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
                <StackPanel x:Name="ViewLimpieza" Visibility="Collapsed">
                    <TextBlock Text="LIMPIEZA DE TEMPORALES" FontSize="28" FontWeight="Black" Foreground="White"/>
                    <TextBlock Text="Limpia únicamente archivos temporales del usuario; algunos pueden estar en uso." Foreground="#A1A1AA" Margin="0,6,0,22"/>
                    <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="760" HorizontalAlignment="Left">
                        <StackPanel>
                            <TextBlock Text="Liberar archivos temporales" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                            <TextBlock Text="Revisa y confirma antes de eliminar. No borra Descargas, documentos ni archivos personales." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,8,0,16"/>
                            <Button x:Name="BtnCleanTemp" Content="LIMPIAR TEMPORALES DEL USUARIO" HorizontalAlignment="Left" Background="#581C87"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
                <StackPanel x:Name="ViewIso" Visibility="Collapsed">
                    <TextBlock Text="DESCARGAS OFICIALES" FontSize="28" FontWeight="Black" Foreground="White"/>
                    <TextBlock Text="Enlaces oficiales de Microsoft para evitar imágenes ISO modificadas." Foreground="#A1A1AA" Margin="0,6,0,22"/>
                    <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="760" HorizontalAlignment="Left">
                        <StackPanel>
                            <TextBlock Text="Windows 11" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                            <TextBlock Text="Se abrirá el sitio oficial de descarga de Microsoft en tu navegador." Foreground="#A1A1AA" Margin="0,8,0,16"/>
                            <Button x:Name="BtnOpenIso" Content="ABRIR DESCARGA OFICIAL" HorizontalAlignment="Left" Background="#581C87"/>
                        </StackPanel>
                    </Border>
                </StackPanel>

                <ScrollViewer x:Name="ViewDrivers" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,8,20">
                        <TextBlock Text="DRIVERS RECOMENDADOS" FontSize="28" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Detecta el adaptador gráfico y abre la página oficial del fabricante. K0R1 no descarga ni instala controladores automáticamente." TextWrapping="Wrap" Foreground="#A1A1AA" Margin="0,6,0,22"/>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="22" MaxWidth="900" HorizontalAlignment="Left">
                            <StackPanel>
                                <TextBlock Text="GPU detectada" FontSize="13" Foreground="#A1A1AA"/>
                                <TextBlock x:Name="LblDetectedGpu" Text="Buscando adaptador gráfico..." FontSize="20" FontWeight="Bold" Foreground="#C084FC" Margin="0,6,0,8" TextWrapping="Wrap"/>
                                <TextBlock x:Name="LblDriverAdvice" Text="Pulsa Detectar para identificar tu gráfica y recomendar la página oficial." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,0,0,16"/>
                                <WrapPanel>
                                    <Button x:Name="BtnDetectGpu" Content="DETECTAR MI GPU" Background="#581C87" Margin="0,0,10,8" Padding="16,8"/>
                                    <Button x:Name="BtnDriverNvidia" Content="DRIVER NVIDIA" Background="#202020" Margin="0,0,10,8" Padding="16,8"/>
                                    <Button x:Name="BtnDriverAmd" Content="DRIVER AMD RADEON" Background="#202020" Margin="0,0,10,8" Padding="16,8"/>
                                    <Button x:Name="BtnDriverIntel" Content="DRIVER INTEL" Background="#202020" Margin="0,0,10,8" Padding="16,8"/>
                                </WrapPanel>
                            </StackPanel>
                        </Border>
                        <TextBlock Text="Consejo: descarga el controlador que corresponda al modelo exacto y a tu versión de Windows. Evita páginas de terceros y no instales varios paquetes a la vez." Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,18,0,0" MaxWidth="900"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- NUEVA VISTA: OPTIMIZACIÓN PRO + CATÁLOGO DE PLANES -->
                <ScrollViewer x:Name="ViewPro" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,8,22">
                        <TextBlock Text="K0R1 // PRO PERFORMANCE" FontSize="28" FontWeight="Black" Foreground="White"/>
                        <TextBlock Text="Herramientas reales y reversibles para Windows 11. No se prometen FPS mágicos ni latencia cero." FontSize="13" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,5,0,20"/>
                        <Border Background="#11101A" BorderBrush="#6D28D9" BorderThickness="1" CornerRadius="14" Padding="18" MaxWidth="940" HorizontalAlignment="Left" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Text="BIOS / UEFI — comprobación segura" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="XMP/EXPO, C-States, PCIe y voltajes dependen de la placa, CPU y RAM. K0R1 no puede configurarlos automáticamente desde Windows; un voltaje incorrecto puede causar inestabilidad o daños. Revisa los valores del fabricante y cambia solo opciones que entiendas." Foreground="#D4D4D8" TextWrapping="Wrap" Margin="0,7,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnProMsInfo" Content="VER INFORMACIÓN DEL SISTEMA" Background="#581C87" Foreground="White" Padding="14,8" Margin="0,0,8,8"/>
                                    <Button x:Name="BtnProRecovery" Content="ABRIR RECUPERACIÓN / UEFI" Background="#27272A" Foreground="White" Padding="14,8" Margin="0,0,8,8"/>
                                    <Button x:Name="BtnProPower" Content="PLANES DE ENERGÍA" Background="#27272A" Foreground="White" Padding="14,8" Margin="0,0,8,8"/>
                                </WrapPanel>
                            </StackPanel>
                        </Border>
                        <Border Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="18" MaxWidth="940" HorizontalAlignment="Left" Margin="0,0,0,14">
                            <StackPanel>
                                <TextBlock Text="WINDOWS / SERVICIOS / LATENCIA" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/>
                                <TextBlock Text="No se aplican cambios ocultos al kernel, temporizadores, afinidad o servicios críticos. El botón abre los ajustes de juego de Windows; desde ahí puedes revisar Modo Juego y capturas. DPC latency debe medirse con herramientas de diagnóstico y depende de drivers y hardware." Foreground="#D4D4D8" TextWrapping="Wrap" Margin="0,7,0,12"/>
                                <WrapPanel>
                                    <Button x:Name="BtnProGameMode" Content="AJUSTES DE MODO JUEGO" Background="#581C87" Foreground="White" Padding="14,8" Margin="0,0,8,8"/>
                                    <Button x:Name="BtnProDeviceMgr" Content="ADMINISTRADOR DE DISPOSITIVOS" Background="#27272A" Foreground="White" Padding="14,8" Margin="0,0,8,8"/>
                                </WrapPanel>
                            </StackPanel>
                        </Border>
                        <TextBlock Text="PLANES / CATÁLOGO INFORMATIVO" FontSize="22" FontWeight="Black" Foreground="White" Margin="0,10,0,12"/>
                        <TextBlock Text="Estos planes se muestran como información. Los botones no cobran ni crean suscripciones; hace falta un enlace oficial de compra para integrar un pago real." FontSize="12" Foreground="#A1A1AA" TextWrapping="Wrap" Margin="0,0,0,14"/>
                        <WrapPanel>
                            <Border Width="270" Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="16" Margin="0,0,12,12">
                                <StackPanel>
                                    <TextBlock Text="STARTER K0R1" FontSize="17" FontWeight="Black" Foreground="#C084FC"/>
                                    <TextBlock Text="$9 USD · pago único" FontSize="22" FontWeight="Bold" Foreground="White" Margin="0,8,0,8"/>
                                    <TextBlock Text="Precio indicado por el usuario: $9 USD, pago único.
• Ajustes de energía
• Gestión de servicios
• Perfiles y actualizaciones
• Windows 10/11" Foreground="#D4D4D8" TextWrapping="Wrap"/>
                                    <Button x:Name="BtnPlanUtility" Content="SOLICITAR PLAN" Background="#581C87" Foreground="White" Padding="10,8" Margin="0,14,0,0"/>
                                </StackPanel>
                            </Border>
                            <Border Width="270" Background="#11101A" BorderBrush="#30233F" BorderThickness="1" CornerRadius="14" Padding="16" Margin="0,0,12,12">
                                <StackPanel>
                                    <TextBlock Text="K0R1 PRO" FontSize="17" FontWeight="Black" Foreground="#C084FC"/>
                                    <TextBlock Text="$25 USD · pago único" FontSize="21" FontWeight="Bold" Foreground="White" Margin="0,8,0,8"/>
                                    <TextBlock Text="Aprox. $500 MXN (precio indicado por el usuario).
• Optimización manual Win 10/11
• CPU y limpieza
• Revisión BIOS segura
• 12 días de soporte
• 1 mes de Utility" Foreground="#D4D4D8" TextWrapping="Wrap"/>
                                    <Button x:Name="BtnPlanExtreme" Content="SOLICITAR PLAN" Background="#27272A" Foreground="White" Padding="10,8" Margin="0,14,0,0"/>
                                </StackPanel>
                            </Border>
                            <Border Width="270" Background="#11101A" BorderBrush="#7C3AED" BorderThickness="1.5" CornerRadius="14" Padding="16" Margin="0,0,12,12">
                                <StackPanel>
                                    <TextBlock Text="★ K0R1 SUPREME" FontSize="17" FontWeight="Black" Foreground="#C084FC"/>
                                    <TextBlock Text="$35 USD · pago único" FontSize="21" FontWeight="Bold" Foreground="White" Margin="0,8,0,8"/>
                                    <TextBlock Text="Aprox. $700 MXN (precio indicado por el usuario).
• Perfiles por juego
• Ajustes avanzados de red
• OC/UV sujeto a hardware y estabilidad
• 15 días de soporte
• 2 meses de Utility" Foreground="#D4D4D8" TextWrapping="Wrap"/>
                                    <Button x:Name="BtnPlanSupreme" Content="SOLICITAR PLAN" Background="#581C87" Foreground="White" Padding="10,8" Margin="0,14,0,0"/>
                                </StackPanel>
                            </Border>
                        </WrapPanel>
                        <TextBlock Text="Aviso: ninguna optimización garantiza 0 input lag, FPS estables en todos los juegos o una mejora automática. Evita overclock/voltajes extremos y descarga drivers solo desde el fabricante oficial." Foreground="#FBBF24" TextWrapping="Wrap" MaxWidth="900" Margin="0,6,0,10"/>
                    </StackPanel>
                </ScrollViewer>

                <!-- VISTA COMPRA / ACTIVACIÓN MANUAL -->
                <ScrollViewer x:Name="ViewCompra" Visibility="Collapsed" VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="0,0,8,20">
                        <TextBlock Text="K0R1 // PLANES Y COMPRA" FontSize="28" FontWeight="Black" Foreground="#E9D5FF"/>
                        <TextBlock Text="Elige tu nivel. Puedes transferir a la cuenta indicada abajo; antes de enviar dinero, confirma que el titular y el banco coincidan con el administrador por WhatsApp." Foreground="#D4D4D8" TextWrapping="Wrap" Margin="0,8,0,18"/>
                        <WrapPanel>
                            <Border Width="245" Background="#11101A" BorderBrush="#3F3F46" BorderThickness="1" CornerRadius="14" Padding="15" Margin="0,0,10,10">
                                <StackPanel><TextBlock Text="BÁSICO" FontSize="18" FontWeight="Bold" Foreground="#A7F3D0"/><TextBlock Text="GRATIS · $0" FontSize="23" FontWeight="Black" Foreground="White" Margin="0,7,0,8"/><TextBlock Text="Acceso básico: inicio, monitor y diagnóstico de componentes/FPS. No incluye herramientas PRO." Foreground="#D4D4D8" TextWrapping="Wrap"/><Button x:Name="BtnCompraGratis" Content="USAR PLAN GRATIS" Background="#166534" Foreground="White" Padding="10,8" Margin="0,12,0,0"/></StackPanel>
                            </Border>
                            <Border Width="245" Background="#11101A" BorderBrush="#6D28D9" BorderThickness="1" CornerRadius="14" Padding="15" Margin="0,0,10,10">
                                <StackPanel><TextBlock Text="STARTER" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/><TextBlock Text="$9 USD · pago único" FontSize="21" FontWeight="Black" Foreground="White" Margin="0,7,0,8"/><TextBlock Text="Código de activación entregado tras validar el plan.`nIncluye nivel básico y herramientas iniciales de tweaks reversibles." Foreground="#D4D4D8" TextWrapping="Wrap"/><Button x:Name="BtnCompra9" Content="SOLICITAR PLAN $9" Background="#581C87" Foreground="White" Padding="10,8" Margin="0,12,0,0"/></StackPanel>
                            </Border>
                            <Border Width="245" Background="#11101A" BorderBrush="#7C3AED" BorderThickness="1" CornerRadius="14" Padding="15" Margin="0,0,10,10">
                                <StackPanel><TextBlock Text="PRO" FontSize="18" FontWeight="Bold" Foreground="#C084FC"/><TextBlock Text="$25 USD · pago único" FontSize="21" FontWeight="Black" Foreground="White" Margin="0,7,0,8"/><TextBlock Text="Código de activación entregado tras validar el plan.`nIncluye Starter, perfiles de Fortnite, red y herramientas avanzadas seguras." Foreground="#D4D4D8" TextWrapping="Wrap"/><Button x:Name="BtnCompra25" Content="SOLICITAR PLAN $25" Background="#581C87" Foreground="White" Padding="10,8" Margin="0,12,0,0"/></StackPanel>
                            </Border>
                            <Border Width="245" Background="#11101A" BorderBrush="#A855F7" BorderThickness="1.5" CornerRadius="14" Padding="15" Margin="0,0,10,10">
                                <StackPanel><TextBlock Text="SUPREME" FontSize="18" FontWeight="Bold" Foreground="#E9D5FF"/><TextBlock Text="$35 USD · pago único" FontSize="21" FontWeight="Black" Foreground="White" Margin="0,7,0,8"/><TextBlock Text="Código de activación entregado tras validar el plan.`nIncluye el nivel PRO y todas las herramientas de usuario disponibles. No incluye permisos de administrador." Foreground="#D4D4D8" TextWrapping="Wrap"/><Button x:Name="BtnCompra35" Content="SOLICITAR PLAN $35" Background="#6D28D9" Foreground="White" Padding="10,8" Margin="0,12,0,0"/></StackPanel>
                            </Border>
                        </WrapPanel>
                        <Border Background="#15111F" BorderBrush="#7C3AED" BorderThickness="1" CornerRadius="12" Padding="18" Margin="0,6,0,12">
                            <StackPanel><TextBlock Text="¿CÓMO COMPRAR?" FontSize="19" FontWeight="Bold" Foreground="#E9D5FF"/><TextBlock Text="1. Elige un plan. 2. Verifica con el administrador por WhatsApp que la cuenta y el titular sean correctos. 3. Realiza la transferencia solo después de confirmar. 4. Envía el comprobante al administrador; el código se entrega cuando el pago sea verificado. Esta app no comprueba transferencias ni activa compras automáticamente." TextWrapping="Wrap" Foreground="#D4D4D8" Margin="0,8,0,12"/><WrapPanel><Button x:Name="BtnCompraWhatsApp" Content="CONTACTAR POR WHATSAPP" Background="#166534" Foreground="White" Padding="14,9" Margin="0,0,8,8"/><Button x:Name="BtnCompraCorreo" Content="ESCRIBIR AL CORREO" Background="#27272A" Foreground="White" Padding="14,9" Margin="0,0,8,8"/></WrapPanel><TextBlock Text="CUENTA PARA TRANSFERENCIA (dato proporcionado por el administrador):" FontSize="13" FontWeight="Bold" Foreground="#FBBF24" Margin="0,10,0,4"/><TextBlock Text="4217 47031019 2139" FontSize="21" FontWeight="Black" Foreground="White" Margin="0,0,0,6"/><TextBlock Text="Confirma banco, titular y número de cuenta por WhatsApp antes de pagar. El correo del administrador aún debe configurarse." Foreground="#FBBF24" TextWrapping="Wrap"/></StackPanel>
                        </Border>
                        <TextBlock Text="TWEAKS MÁXIMOS, PERO SEGUROS: usar Modo Juego, desactivar capturas en segundo plano si no las usas, seleccionar un plan de energía apropiado, actualizar drivers desde AMD/NVIDIA oficiales, cerrar aplicaciones de inicio que reconozcas y guardar copia antes de editar la configuración de Fortnite. No se desactiva Defender, no se borran archivos del juego y no se aplican voltajes/overclock automáticos. Ningún tweak garantiza FPS extra." Foreground="#FBBF24" TextWrapping="Wrap" Margin="0,4,0,12"/>
                    </StackPanel>
                </ScrollViewer>

            </Grid>
        </Grid>
    </Grid>
</Window>
'@

$readerMain = (New-Object System.Xml.XmlNodeReader $xamlMain)
$windowMain = [System.Windows.Markup.XamlReader]::Load($readerMain)

# COMPONENTES DE VISTA
$vRegister  = $windowMain.FindName("ViewRegister")
$vLogin     = $windowMain.FindName("ViewLogin")
$vAppMain   = $windowMain.FindName("ViewAppMain")

$txtEmail   = $windowMain.FindName("TxtEmail")
$btnReg     = $windowMain.FindName("BtnRegister")
$txtPin     = $windowMain.FindName("TxtPin")
$btnLogin   = $windowMain.FindName("BtnLogin")
$btnGoogleRegister = $windowMain.FindName("BtnGoogleRegister")
$btnGoogleLogin = $windowMain.FindName("BtnGoogleLogin")
$btnBackRegister = $windowMain.FindName("BtnBackRegister")

$lblRole    = $windowMain.FindName("LblRoleDisplay")
$lblEmail   = $windowMain.FindName("LblEmailDisplay")

# VISTAS INTERNAS
$vInicio   = $windowMain.FindName("ViewInicio")
$vAi       = $windowMain.FindName("ViewAi")
$vTweaks   = $windowMain.FindName("ViewTweaks")
$vBiosRgb  = $windowMain.FindName("ViewBiosRgb")

$nInicio   = $windowMain.FindName("NavInicio")
$nAi       = $windowMain.FindName("NavAi")
$nTweaks   = $windowMain.FindName("NavTweaks")
$nBiosRgb  = $windowMain.FindName("NavBiosRgb")

# --- GOOGLE OAUTH REAL (OAuth 2.0 Authorization Code + PKCE) ---
# Mejora adicional: diagnóstico de errores HTTP compatible con Windows PowerShell 5.1 y PS7.
# Requiere un OAuth Client ID de tipo "Desktop app" creado por el propietario en Google Cloud.
# Guarda SOLO el Client ID público en google-client-id.txt junto a este .ps1. Nunca pongas secretos aquí.
function Start-K0R1GoogleOAuth {
    $clientFile = Join-Path $PSScriptRoot 'google-client-id.txt'
    if (-not (Test-Path -LiteralPath $clientFile)) {
        [System.Windows.MessageBox]::Show(
            "Para iniciar sesión de verdad, crea un OAuth Client ID de tipo Desktop app en Google Cloud Console y guarda el ID en:`n$clientFile`n`nNo se necesita ni debe guardarse un Client Secret en este script. Después vuelve a pulsar Google.",
            "Configurar Google OAuth",
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Information
        ) | Out-Null
        Start-Process 'https://console.cloud.google.com/apis/credentials'
        return
    }

    $clientId = (Get-Content -LiteralPath $clientFile -Raw).Trim()
    if ($clientId -notmatch '^[0-9]+-[a-zA-Z0-9_-]+\.apps\.googleusercontent\.com$') {
        [System.Windows.MessageBox]::Show("El archivo google-client-id.txt no contiene un Client ID de Google válido.", "OAuth", "OK", "Warning") | Out-Null
        return
    }

    $listener = $null
    try {
        $port = Get-Random -Minimum 49152 -Maximum 62000
        $redirectUri = "http://127.0.0.1:$port/"
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add($redirectUri)
        $listener.Start()

        $randomBytes = New-Object byte[] 32
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($randomBytes)
        $verifier = [Convert]::ToBase64String($randomBytes).TrimEnd('=').Replace('+','-').Replace('/','_')
        $sha = [System.Security.Cryptography.SHA256]::Create()
        $challengeBytes = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($verifier))
        $challenge = [Convert]::ToBase64String($challengeBytes).TrimEnd('=').Replace('+','-').Replace('/','_')
        $stateBytes = New-Object byte[] 24
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($stateBytes)
        $state = [Convert]::ToBase64String($stateBytes).TrimEnd('=').Replace('+','-').Replace('/','_')

        $query = "client_id=$([uri]::EscapeDataString($clientId))&redirect_uri=$([uri]::EscapeDataString($redirectUri))&response_type=code&scope=$([uri]::EscapeDataString('openid email profile'))&state=$([uri]::EscapeDataString($state))&code_challenge=$([uri]::EscapeDataString($challenge))&code_challenge_method=S256&access_type=online"
        Start-Process ("https://accounts.google.com/o/oauth2/v2/auth?$query")
        $async = $listener.GetContextAsync()
        if (-not $async.Wait(180000)) { throw "Tiempo de espera agotado al iniciar sesión." }
        $context = $async.GetAwaiter().GetResult()
        $req = $context.Request
        $resp = $context.Response
        $returnedState = $req.QueryString['state']
        $code = $req.QueryString['code']
        $error = $req.QueryString['error']
        $html = '<html><body style="font-family:Segoe UI;background:#0b0b12;color:white;text-align:center;padding:50px"><h2>K0R1 OPTIMIZER</h2><p>Respuesta recibida. Puedes volver a la aplicación.</p></body></html>'
        $bytes = [Text.Encoding]::UTF8.GetBytes($html)
        $resp.ContentType = 'text/html; charset=utf-8'
        $resp.ContentLength64 = $bytes.Length
        $resp.OutputStream.Write($bytes,0,$bytes.Length)
        $resp.Close()
        if ($error) { throw "Google canceló o rechazó la autorización: $error" }
        if (-not $code -or $returnedState -ne $state) { throw "La respuesta OAuth no pasó la validación de estado." }

        # Intercambio OAuth por HttpWebRequest para capturar el cuerpo HTTP real
        # en Windows PowerShell 5.1 y PowerShell 7. No se guarda el código ni los tokens.
        $formParts = @(
            ('client_id=' + [uri]::EscapeDataString($clientId)),
            ('code=' + [uri]::EscapeDataString($code)),
            ('code_verifier=' + [uri]::EscapeDataString($verifier)),
            ('redirect_uri=' + [uri]::EscapeDataString($redirectUri)),
            ('grant_type=authorization_code')
        )
        $formBody = $formParts -join '&'
        $token = $null
        $request = [System.Net.HttpWebRequest]::Create('https://oauth2.googleapis.com/token')
        $request.Method = 'POST'
        $request.ContentType = 'application/x-www-form-urlencoded'
        $request.Accept = 'application/json'
        $request.Timeout = 30000
        $request.ReadWriteTimeout = 30000
        $request.UserAgent = 'K0R1-AURA-JARVIS/1.0'
        $request.AllowAutoRedirect = $false
        $requestBodyBytes = [System.Text.Encoding]::UTF8.GetBytes($formBody)
        $request.ContentLength = $requestBodyBytes.Length

        try {
            $requestStream = $request.GetRequestStream()
            try { $requestStream.Write($requestBodyBytes, 0, $requestBodyBytes.Length) }
            finally { $requestStream.Dispose() }

            $response = $request.GetResponse()
            try {
                $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
                try { $tokenJson = $reader.ReadToEnd() }
                finally { $reader.Dispose() }
                $token = $tokenJson | ConvertFrom-Json -ErrorAction Stop
            }
            finally { $response.Close() }
        }
        catch [System.Net.WebException] {
            $httpStatus = 'sin respuesta HTTP'
            $bodyText = ''
            $webError = $_.Exception
            if ($webError.Response) {
                try { $httpStatus = [string][int]$webError.Response.StatusCode } catch {}
                try {
                    $errorStream = $webError.Response.GetResponseStream()
                    if ($errorStream) {
                        $errorReader = New-Object System.IO.StreamReader($errorStream)
                        try { $bodyText = $errorReader.ReadToEnd() }
                        finally { $errorReader.Dispose() }
                    }
                } catch {}
                try { $webError.Response.Close() } catch {}
            }

            $googleError = ''
            $googleDescription = ''
            if ($bodyText) {
                try {
                    $errorObject = $bodyText | ConvertFrom-Json -ErrorAction Stop
                    $googleError = [string]$errorObject.error
                    $googleDescription = [string]$errorObject.error_description
                } catch {}
            }

            # Diagnóstico accionable: nunca incluye el código OAuth ni credenciales.
            $advice = switch -Regex ($googleError) {
                '^invalid_grant$' { 'El código expiró/se reutilizó o el redirect_uri/code_verifier no coincide. Cierra la ventana e intenta una sola vez; confirma que la app usa el mismo redirect_uri recibido.'; break }
                '^invalid_client$' { 'Google no reconoce el Client ID. Revisa que google-client-id.txt tenga el ID completo de un cliente OAuth de tipo Aplicación de escritorio.'; break }
                '^unauthorized_client$' { 'El tipo de cliente o el flujo no está permitido. Crea/selecciona un cliente OAuth de Aplicación de escritorio.'; break }
                '^invalid_request$' { 'Google rechazó parámetros del intercambio. Revisa el tipo de cliente y que no hayas editado manualmente el Client ID.'; break }
                default { 'Comprueba el código de error y su descripción en Google Cloud Console > Google Auth Platform. No compartas códigos ni tokens.' }
            }
            $safeDescription = ($googleDescription -replace '[\r\n]+', ' ').Trim()
            if ($safeDescription.Length -gt 500) { $safeDescription = $safeDescription.Substring(0, 500) }
            throw ("OAuth_TOKEN_ERROR|HTTP={0}|ERROR={1}|DESCRIPCION={2}|AYUDA={3}" -f $httpStatus, $googleError, $safeDescription, $advice)
        }
        catch {
            if ($_.Exception.Message -like 'OAuth_TOKEN_ERROR|*') { throw }
            throw ("OAuth_TOKEN_ERROR|HTTP=respuesta no válida|ERROR=respuesta_parseo|DESCRIPCION={0}|AYUDA=Revisa conexión HTTPS y hora/fecha de Windows." -f ($_.Exception.Message -replace '[\r\n]+',' '))
        }
        finally {
            $formBody = $null
            $requestBodyBytes = $null
        }
        if (-not $token.access_token) { throw "Google no devolvió un token válido." }
        $profile = Invoke-RestMethod -Method Get -Uri 'https://openidconnect.googleapis.com/v1/userinfo' -Headers @{ Authorization = "Bearer $($token.access_token)" } -TimeoutSec 30
        if (-not $profile.email -or $profile.email_verified -ne $true) { throw "Google no confirmó un correo verificado." }

        $global:UserEmail = [string]$profile.email
        $global:GoogleAuthenticated = $true
        $txtEmail.Text = $global:UserEmail
        $txtPin.Password = ''
        $vRegister.Visibility = 'Collapsed'
        $vLogin.Visibility = 'Collapsed'
        $vAppMain.Visibility = 'Visible'
        $lblRole.Text = 'Rango: Google verificado'
        $lblEmail.Text = "User: $global:UserEmail"
        # Google login only unlocks FREE mode in this local client. A real paid tier requires server-side authorization.
        $freeNav = @('NavInicio', 'NavTweaks', 'NavFortnite', 'NavHardwareFPS', 'NavCompra')
        foreach ($navName in @('NavInicio', 'NavAi', 'NavTweaks', 'NavBiosRgb', 'NavStartup', 'NavRed', 'NavFortnite', 'NavHardwareFPS', 'NavMega', 'NavLimpieza', 'NavIso', 'NavDrivers', 'NavPro', 'NavCompra')) {
            $navControl = $windowMain.FindName($navName)
            if ($null -ne $navControl) {
                $navControl.Visibility = if ($navName -in $freeNav) { [System.Windows.Visibility]::Visible } else { [System.Windows.Visibility]::Collapsed }
            }
        }
        $lblRole.Text = 'Rango: FREE • Google verificado'
        if ($null -ne $nInicio) { $nInicio.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent)) }
    }
    catch {
        $safeMessage = [string]$_.Exception.Message
        # No mostrar ni registrar el código de autorización, verifier, access token ni refresh token.
        $safeMessage = $safeMessage -replace '(?i)(access_token|refresh_token|code_verifier|client_secret)=?[^&\s]*', '$1=[REDACTADO]'
        [System.Windows.MessageBox]::Show("No se pudo completar el inicio de sesión con Google.`n`nDetalle técnico: $safeMessage`n`nRevisa la causa indicada en ERROR/DESCRIPCION. No compartas códigos de autorización, tokens ni secretos. Google OAuth necesita un Client ID de tipo Aplicación de escritorio en google-client-id.txt.", "Diagnóstico Google OAuth", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning) | Out-Null
    }
    finally {
        if ($listener) { try { if ($listener.IsListening) { $listener.Stop() }; $listener.Close() } catch {} }
    }
}
$googleClick = { Start-K0R1GoogleOAuth }
if ($null -ne $btnGoogleRegister) { $btnGoogleRegister.Add_Click($googleClick) }
if ($null -ne $btnGoogleLogin) { $btnGoogleLogin.Add_Click($googleClick) }
if ($null -ne $btnBackRegister) {
    $btnBackRegister.Add_Click({ $vLogin.Visibility = 'Collapsed'; $vRegister.Visibility = 'Visible' })
}

$btnReg.Add_Click({
    $email = $txtEmail.Text.Trim()
    if (-not [string]::IsNullOrWhiteSpace($email) -and $email -notmatch "^[^\s@]+@[^\s@]+\.[^\s@]+$") {
        $txtEmail.BorderBrush = [System.Windows.Media.Brushes]::Red
        [System.Windows.MessageBox]::Show("Introduce un correo válido o deja el campo vacío.", "Atención", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    
    $global:UserEmail = $email
    $txtEmail.BorderBrush = [System.Windows.Media.Brushes]::Gray
    [System.Windows.MessageBox]::Show("Perfil local listo.`n`nAhora introduce tu código de acceso.`nAVISO: esta versión valida códigos de demostración dentro del script; todavía no crea cuentas únicas verificadas en un servidor.", "Éxito", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    
    # Transición limpia hacia Login
    $vRegister.Visibility = "Collapsed"
    $vLogin.Visibility = "Visible"
})

# --- LÓGICA DE LOGIN SEGURO ---
$validadorLogin = {
    $enteredPin = $txtPin.Password
    $role = ""

    if ($enteredPin -eq "201314") { $role = "Administrador · acceso total" }
    elseif ($enteredPin -eq "111222") { $role = "Starter · `$9 USD" }
    elseif ($enteredPin -eq "777888") { $role = "PRO · `$25 USD" }
    elseif ($enteredPin -eq "444555") { $role = "Gratis · Básico" }
    elseif ($enteredPin -eq "999999") { $role = "Supreme · `$35 USD" }
    
    if ($role -ne "") {
        $global:UserRole = $role
        $lblRole.Text = "Rango: $role"
        $lblEmail.Text = "User: $global:UserEmail"
        
        # Transición hacia Panel Principal
        $vLogin.Visibility = "Collapsed"
        $vAppMain.Visibility = "Visible"

        # Menú por nivel. Es una restricción de interfaz local, no un sistema de licencias seguro.
        $basicNav = @("NavInicio", "NavHardwareFPS", "NavCompra")
        $starterNav = $basicNav + @("NavTweaks", "NavFortnite")
        $proNav = $starterNav + @("NavRed", "NavMega", "NavLimpieza")
        $supremeNav = $proNav + @("NavAi", "NavBiosRgb", "NavStartup", "NavIso", "NavDrivers", "NavPro")
        $allowedNav = $supremeNav
        if ($enteredPin -eq "444555") { $allowedNav = $basicNav }
        elseif ($enteredPin -eq "111222") { $allowedNav = $starterNav }
        elseif ($enteredPin -eq "777888") { $allowedNav = $proNav }
        elseif ($enteredPin -eq "999999" -or $enteredPin -eq "201314") { $allowedNav = $supremeNav }
        foreach ($navName in @("NavInicio", "NavAi", "NavTweaks", "NavBiosRgb", "NavStartup", "NavRed", "NavFortnite", "NavHardwareFPS", "NavMega", "NavLimpieza", "NavIso", "NavDrivers", "NavPro", "NavCompra")) {
            $navControl = $windowMain.FindName($navName)
            if ($null -ne $navControl) {
                if ($allowedNav -contains $navName) { $navControl.Visibility = [System.Windows.Visibility]::Visible }
                else { $navControl.Visibility = [System.Windows.Visibility]::Collapsed }
            }
        }

        # Saludo de bienvenida: voz sintética instalada, estilo de asistente británico si existe.
        if (-not $global:K0R1GreetingPlayed) {
            $global:K0R1GreetingPlayed = $true
            $greeting = "Buenas. K0R1 AURA está en línea. Sistemas listos. Puedo analizar tus componentes y estimar los FPS de Fortnite."
            try {
                if ($null -ne $txtChat) {
                    $txtChat.AppendText("JARVIS: $greeting`r`n`r`n")
                    $txtChat.ScrollToEnd()
                }
                if ($null -ne $synth) {
                    # Mantiene la misma voz española seleccionada para las respuestas de la IA.
                    $synth.Rate = -2
                    $synth.Volume = 100
                    # SpeakAsync avoids freezing the WPF interface while the greeting is playing.
                    $synth.SpeakAsyncCancelAll()
                    $null = $synth.SpeakAsync($greeting)
                }
            } catch {
                # Si no hay una voz inglesa instalada, el panel sigue funcionando sin audio.
            }
        }
    } else {
        $txtPin.BorderBrush = [System.Windows.Media.Brushes]::Red
        [System.Windows.MessageBox]::Show("Código secreto incorrecto. Inténtalo de nuevo.", "Acceso Denegado", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        $txtPin.Password = ""
    }
}

$btnLogin.Add_Click($validadorLogin)
$txtPin.Add_KeyDown({ if ($_.Key -eq "Enter") { & $validadorLogin } })

# --- NAVEGACIÓN: TODAS LAS SECCIONES ---
$vStartup = $windowMain.FindName("ViewStartup")
$vRed = $windowMain.FindName("ViewRed")
$vFortnite = $windowMain.FindName("ViewFortnite")
$vHardwareFPS = $windowMain.FindName("ViewHardwareFPS")
$vMega = $windowMain.FindName("ViewMega")
$vLimpieza = $windowMain.FindName("ViewLimpieza")
$vIso = $windowMain.FindName("ViewIso")
$vDrivers = $windowMain.FindName("ViewDrivers")
$vPro = $windowMain.FindName("ViewPro")
$vCompra = $windowMain.FindName("ViewCompra")

$allViews = @($vInicio, $vAi, $vTweaks, $vBiosRgb, $vStartup, $vRed, $vFortnite, $vHardwareFPS, $vMega, $vLimpieza, $vIso, $vDrivers, $vPro, $vCompra)
$navMap = @(
    @{ Button = "NavInicio"; View = $vInicio },
    @{ Button = "NavAi"; View = $vAi },
    @{ Button = "NavTweaks"; View = $vTweaks },
    @{ Button = "NavBiosRgb"; View = $vBiosRgb },
    @{ Button = "NavStartup"; View = $vStartup },
    @{ Button = "NavRed"; View = $vRed },
    @{ Button = "NavFortnite"; View = $vFortnite },
    @{ Button = "NavHardwareFPS"; View = $vHardwareFPS },
    @{ Button = "NavMega"; View = $vMega },
    @{ Button = "NavLimpieza"; View = $vLimpieza },
    @{ Button = "NavIso"; View = $vIso },
    @{ Button = "NavDrivers"; View = $vDrivers },
    @{ Button = "NavPro"; View = $vPro },
    @{ Button = "NavCompra"; View = $vCompra }
)
function Show-K0R1View($targetView) {
    foreach ($view in $allViews) { if ($null -ne $view) { $view.Visibility = "Collapsed" } }
    if ($null -ne $targetView) { $targetView.Visibility = "Visible" }
}
foreach ($entry in $navMap) {
    $navButton = $windowMain.FindName($entry.Button)
    $target = $entry.View
    $viewsForHandler = $allViews
    if ($null -ne $navButton) {
        $navButton.Add_Click({
            foreach ($viewItem in $viewsForHandler) {
                if ($null -ne $viewItem) { $viewItem.Visibility = [System.Windows.Visibility]::Collapsed }
            }
            if ($null -ne $target) { $target.Visibility = [System.Windows.Visibility]::Visible }
        }.GetNewClosure())
    }
}

# --- VOZ AURA / JARVIS + ASISTENTE LOCAL SIN API ---
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
try {
    $installedVoices = @($synth.GetInstalledVoices() | Where-Object { $_.Enabled })
    $spanishMale = $installedVoices | Where-Object { $_.VoiceInfo.Culture.Name -like 'es-*' -and $_.VoiceInfo.Gender -eq [System.Speech.Synthesis.VoiceGender]::Male } | Select-Object -First 1
    $spanishAny = $installedVoices | Where-Object { $_.VoiceInfo.Culture.Name -like 'es-*' } | Select-Object -First 1
    $britishMale = $installedVoices | Where-Object { $_.VoiceInfo.Culture.Name -eq 'en-GB' -and $_.VoiceInfo.Gender -eq [System.Speech.Synthesis.VoiceGender]::Male } | Select-Object -First 1
    $chosenVoice = if ($spanishMale) { $spanishMale } elseif ($spanishAny) { $spanishAny } elseif ($britishMale) { $britishMale } else { $null }
    if ($chosenVoice) { $synth.SelectVoice($chosenVoice.VoiceInfo.Name) }
    $synth.Rate = -2; $synth.Volume = 100; $synth.SetOutputToDefaultAudioDevice()
} catch {}
$txtChat = $windowMain.FindName('TxtAiChat')
$txtInput = $windowMain.FindName('TxtAiInput')
$aiStatus = $windowMain.FindName('LblAiStatus')
$global:K0R1LastAnswer = 'K0R1 Optimizer está listo. Indícame qué sistema deseas analizar.'

function ConvertTo-K0R1SpeechText([string]$Text) {
    if ([string]::IsNullOrWhiteSpace($Text)) { return 'No hay respuesta para leer.' }
    $spoken = $Text -replace '(?m)^\s*[#>*•\-]+\s*', ''
    $spoken = $spoken -replace '[`*_]', ''
    $spoken = $spoken -replace '(?i)\bCPU\b', 'procesador'
    $spoken = $spoken -replace '(?i)\bGPU\b', 'tarjeta gráfica'
    $spoken = $spoken -replace '(?i)\bRAM\b', 'memoria RAM'
    $spoken = $spoken -replace '(?i)\bFPS\b', 'fotogramas por segundo'
    $spoken = $spoken -replace '(?i)\bN/D\b', 'no disponible'
    $spoken = $spoken -replace '[\r\n]+', '. '
    $spoken = $spoken -replace '\s{2,}', ' '
    if ($spoken.Length -gt 1800) { $spoken = $spoken.Substring(0, 1800) + '. Resumen de voz limitado para mantener la interfaz ágil.' }
    return $spoken.Trim()
}


function Get-K0R1LocalHardwareSummary {
    try {
        $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1
        $gpu = @(Get-CimInstance Win32_VideoController -ErrorAction Stop | Where-Object { $_.Name } | ForEach-Object { $_.Name })
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $ram = [math]::Round(([double]$os.TotalVisibleMemorySize / 1MB), 1)
        return [pscustomobject]@{ CPU=[string]$cpu.Name; GPU=($gpu -join ' | '); RAM=$ram; Windows=[string]$os.Caption }
    } catch { return $null }
}
# --- Diagnóstico AURA AI / Ollama ---
# Solo consulta el endpoint local; no descarga modelos, no cambia ajustes ni envía datos a la nube.
function Test-K0R1LocalAI {
    try {
        $response = Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/tags' -Method Get -TimeoutSec 3 -ErrorAction Stop
        $models = @($response.models | ForEach-Object { [string]$_.name })
        [pscustomobject]@{
            Disponible = $true
            Endpoint = 'http://127.0.0.1:11434'
            Modelos = $models
            Mensaje = if ($models.Count -gt 0) { 'Ollama activo; modelos detectados.' } else { 'Ollama activo, pero no hay modelos descargados.' }
        }
    } catch {
        [pscustomobject]@{
            Disponible = $false
            Endpoint = 'http://127.0.0.1:11434'
            Modelos = @()
            Mensaje = 'Ollama no responde. Inicia Ollama y comprueba que el servicio local esté disponible.'
        }
    }
}

function Get-K0R1OllamaAnswer([string]$question) {
    # Motor de IA real opcional: Ollama ejecutado localmente. No usa API key ni manda el chat a la nube.
    # Si Ollama/modelo no está disponible, el asistente continúa con el motor local integrado.
    try {
        $tags = Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/tags' -Method Get -TimeoutSec 2 -ErrorAction Stop
        $models = @($tags.models)
        if ($models.Count -eq 0) { return $null }
        $preferred = $models | Where-Object { $_.name -match 'qwen2.5|llama3.1|llama3.2|mistral|gemma2' } | Select-Object -First 1
        $model = if ($preferred) { [string]$preferred.name } else { [string]$models[0].name }
        $hw = Get-K0R1LocalHardwareSummary
        $hardwareContext = if ($hw) { "Hardware detectado: CPU=$($hw.CPU); GPU=$($hw.GPU); RAM=$($hw.RAM) GB; Sistema=$($hw.Windows)." } else { 'No se pudo detectar el hardware.' }
        $systemPrompt = @"
Eres K0R1 OPTIMIZER, asistente de IA con personalidad de mayordomo tecnológico elegante, sereno, preciso y ligeramente ingenioso, inspirado en el arquetipo de un asistente cinematográfico de alta tecnología, sin afirmar ser JARVIS ni copiar frases protegidas. Habla en español natural, con frases concisas y seguridad tranquila: puedes iniciar con “A la orden” o “Diagnóstico completado” cuando encaje, pero no repitas muletillas en cada respuesta. Explica qué detectaste, qué significa y qué debe hacer el usuario, paso a paso. No suenes robótico ni exageres. Responde siempre en español, con pasos prácticos y ordenados. $hardwareContext
Usa conocimiento general de informática, Windows, hardware, redes, latencia, gaming y diagnóstico disponible en el modelo local; no afirmes contener toda la base de datos de ChatGPT ni inventes acceso a Internet. Para información actual, indica que hace falta verificar fuentes. Puedes recomendar conceptos públicos conocidos de optimización como los enfoques de Chris Titus Tech (desinstalación selectiva, control de inicio, privacidad y ajustes reversibles), pero no copies scripts propietarios ni ejecutes debloat masivo sin revisión. Prioriza estabilidad, baja latencia, seguridad y cambios reversibles. No inventes mediciones, temperaturas, FPS exactos ni resultados. Si estimas FPS, aclara que son aproximados y dependen de mapa, versión, ajustes y procesos. No recomiendes desactivar Defender/firewall, borrar archivos personales, ejecutar comandos destructivos, modificar voltajes ni overclock automático. Para cambios delicados, explica riesgos y pide confirmación antes de actuar. Esta app no ejecuta acciones solo por conversar: ofrece instrucciones, no afirmes que ya cambiaste el PC. Si no sabes algo, dilo y pide el dato concreto que falta. Mantén las respuestas útiles, con encabezados y listas cuando ayuden.
"@
        $body = @{
            model = $model
            stream = $false
            messages = @(
                @{ role = 'system'; content = $systemPrompt },
                @{ role = 'user'; content = $question }
            )
            options = @{ temperature = 0.35; num_ctx = 4096 }
        } | ConvertTo-Json -Depth 8
        $result = Invoke-RestMethod -Uri 'http://127.0.0.1:11434/api/chat' -Method Post -ContentType 'application/json; charset=utf-8' -Body $body -TimeoutSec 45 -ErrorAction Stop
        if ($result.message -and -not [string]::IsNullOrWhiteSpace([string]$result.message.content)) {
            $global:K0R1AiEngine = "Ollama local / $model"
            return ([string]$result.message.content).Trim()
        }
    } catch { }
    return $null
}
function Get-K0R1LocalAnswer([string]$question) {
    $q = $question.ToLowerInvariant()
    $hw = Get-K0R1LocalHardwareSummary
    $gpuText = if ($hw) { $hw.GPU } else { '' }
    $cpuText = if ($hw) { $hw.CPU } else { '' }
    $ramText = if ($hw) { "$($hw.RAM) GB" } else { 'no detectada' }
    $fps = 'No tengo datos suficientes para dar un rango fiable de esta GPU. Pulsa “Detectar mi PC y estimar FPS” en Mis componentes / FPS.'
    if ($gpuText -match 'RX 7600|RX 6700 XT|RX 6750 XT|RTX 4060 Ti|RTX 4060|RTX 3070') { $fps='Estimación orientativa: 180–320 FPS en modo Rendimiento/bajo a 1720×1080. Depende de la partida y puede limitar la CPU; no es garantía.' }
    elseif ($gpuText -match 'RX 6600|RX 6650 XT|RTX 3060|RTX 2070|RTX 2060 SUPER') { $fps='Estimación orientativa: 150–280 FPS en modo Rendimiento/bajo a 1720×1080. En peleas y finales puede bajar; no es garantía.' }
    elseif ($gpuText -match 'RX 580|RX 590|GTX 1650|GTX 1060|GTX 1660') { $fps='Estimación orientativa: 80–180 FPS en modo Rendimiento/bajo a 1720×1080. Depende del modelo exacto y la RAM; no es garantía.' }
    elseif ($gpuText -match 'RTX 4070|RTX 4080|RTX 4090|RX 7800 XT|RX 7900') { $fps='Estimación orientativa: 200–360+ FPS en modo Rendimiento/bajo a 1720×1080, aunque la CPU puede ser el límite. No es garantía.' }
    elseif ($gpuText -match 'Intel.*UHD|Radeon.*Graphics|Vega 7|Vega 8|Graphics') { $fps='Si son gráficos integrados, el rendimiento suele ser menor y depende mucho de la RAM en doble canal. No puedo fijar un rango fiable solo con el nombre detectado.' }
    if ($q -match 'fps|cuantos cuadros|cuántos cuadros|rendimiento|cuanto corre|cuánto corre') {
        if ($hw) { return "AURA // ANÁLISIS DE FPS`nCPU: $cpuText`nGPU: $gpuText`nRAM: $ramText`n`n$fps`n`nPara afinar: dime el modelo exacto de la GPU y si la RAM es 1×16 o 2×8 GB." }
        return 'No pude leer los componentes automáticamente. Abre Mis componentes / FPS y pulsa Detectar mi PC y estimar FPS.'
    }
    if ($q -match 'componente|mi pc|hardware|analiza mi|analizar mi') {
        if ($hw) { return "AURA // DIAGNÓSTICO DE HARDWARE`nCPU: $cpuText`nGPU: $gpuText`nRAM utilizable: $ramText`nSistema: $($hw.Windows)`n`n$fps`n`nConsejo: para competitivo, revisa temperaturas, uso de CPU/GPU y estabilidad de FPS durante una partida real." }
        return 'No pude detectar el hardware. Entra a Mis componentes / FPS y pulsa el botón de detección.'
    }
    if ($q -match 'tweak|optim|mejorar|configura|ajustes|lag|input lag') {
        return "AURA // PLAN DE OPTIMIZACIÓN SEGURO`n1. Fortnite: modo Rendimiento si funciona mejor en tu PC, pantalla completa y V-Sync desactivado si buscas menor latencia.`n2. Limita FPS a un valor que el equipo mantenga de forma estable; no persigas un número que fluctúe demasiado.`n3. Cierra grabadores y aplicaciones de fondo que reconozcas.`n4. Actualiza el driver desde AMD Adrenalin o NVIDIA oficial.`n5. Activa Modo Juego de Windows y desactiva grabación en segundo plano si no la usas.`n6. Vigila temperaturas y deja espacio libre en el SSD.`nNo desactives Defender ni apliques scripts de registro de origen dudoso. Ningún tweak garantiza FPS extra."
    }
    if ($q -match 'fortnite|epic|competitiv|resoluci') {
        return "AURA // PERFIL FORTNITE COMPETITIVO`nPrueba 1720×1080, modo Rendimiento, sombras desactivadas/bajas, efectos y postprocesado bajos, V-Sync desactivado y límite de FPS estable acorde a tu monitor. Compara partidas reales y cambia una opción a la vez. Si aparecen tirones, revisa RAM, temperaturas y procesos en segundo plano."
    }
    if ($q -match 'hola|buenas|buenos dias|buenas tardes|hey|jarvis|aura') {
        return 'A la orden. K0R1 Optimizer está operativo. Indícame si deseas un diagnóstico de hardware, latencia o rendimiento. Puedo analizar tu hardware, estimar FPS de Fortnite y recomendar ajustes competitivos seguros. Pregunta por FPS, componentes o tweaks.'
    }
    $hardwareNote = if ($hw) { "Detecté CPU $cpuText, GPU $gpuText y $ramText de RAM." } else { 'Aún no he podido detectar tus componentes.' }
    return "K0R1 OPTIMIZER // ASISTENTE LOCAL`nPuedo ayudarte con FPS, componentes, Fortnite y optimización de Windows sin API ni clave.`n`nEjemplos:`n• ¿Cuántos FPS puedo sacar?`n• Analiza mis componentes`n• Dame tweaks seguros para Fortnite`n• Recomienda ajustes competitivos`n`n$hardwareNote"
}
$enviarMensajeAi = {
    $pregunta = $txtInput.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($pregunta)) { return }
    $txtChat.AppendText("TÚ: $pregunta`r`n")
    $txtInput.Text = ''
    $aiStatus.Text = '● AURA ANALIZANDO · buscando motor de IA local…'
    $windowMain.Dispatcher.Invoke([action]{}, [System.Windows.Threading.DispatcherPriority]::Background)
    # Las consultas de FPS/componentes usan primero el estimador integrado para que el botón,
    # el panel de componentes y la respuesta hablada compartan los mismos datos detectados.
    if ($pregunta -match '(?i)fps|cu[aá]ntos cuadros|rendimiento|componentes|mi pc|hardware|analiza mi') {
        $global:K0R1AiEngine = 'Estimador integrado de hardware/FPS'
        $respuestaAi = Get-K0R1LocalAnswer $pregunta
        $aiStatus.Text = '● AURA ACTIVA · hardware y FPS integrados'
    } else {
        $respuestaAi = Get-K0R1OllamaAnswer $pregunta
        if ([string]::IsNullOrWhiteSpace([string]$respuestaAi)) {
            $global:K0R1AiEngine = 'AURA local inteligente (sin modelo externo)'
            $respuestaAi = Get-K0R1LocalAnswer $pregunta
            $aiStatus.Text = '● AURA ACTIVA · modo local integrado (Ollama no detectado)'
        } else {
            $aiStatus.Text = "● AURA ACTIVA · IA generativa local: $global:K0R1AiEngine"
        }
    }
    $global:K0R1LastAnswer = $respuestaAi
    $txtChat.AppendText("`r`nK0R1 OPTIMIZER: $respuestaAi`r`n`r`n")
    $txtChat.ScrollToEnd()
    try { $spoken = ConvertTo-K0R1SpeechText ([string]$respuestaAi); $synth.SpeakAsyncCancelAll(); $null = $synth.SpeakAsync($spoken) } catch {}
}
$windowMain.FindName('BtnAiSend').Add_Click($enviarMensajeAi)
$txtInput.Add_KeyDown({ if ($_.Key -eq 'Enter') { & $enviarMensajeAi } })
$windowMain.FindName('BtnAiSpeak').Add_Click({ try { $spoken = ConvertTo-K0R1SpeechText ([string]$global:K0R1LastAnswer); $synth.SpeakAsyncCancelAll(); $null = $synth.SpeakAsync($spoken) } catch {} })

# --- DETECCIÓN DE COMPONENTES Y ESTIMACIÓN PRUDENTE DE FPS ---
$windowMain.FindName("BtnDetectHardwareFPS").Add_Click({
    $cpuLabel = $windowMain.FindName("LblHardwareCPU")
    $gpuLabel = $windowMain.FindName("LblHardwareGPU")
    $ramLabel = $windowMain.FindName("LblHardwareRAM")
    $winLabel = $windowMain.FindName("LblHardwareWindows")
    $fpsLabel = $windowMain.FindName("LblHardwareFPS")
    try {
        $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1
        $gpus = @(Get-CimInstance Win32_VideoController -ErrorAction Stop | Where-Object { $_.Name })
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $ramGB = [math]::Round(([double]$os.TotalVisibleMemorySize / 1MB), 1)
        $cpuLabel.Text = "CPU: $($cpu.Name)"
        $gpuNames = @($gpus | ForEach-Object { $_.Name })
        $gpuLabel.Text = "GPU: " + ($gpuNames -join " | ")
        $ramLabel.Text = "RAM utilizable: $ramGB GB"
        $winLabel.Text = "Windows: $($os.Caption) (build $($os.BuildNumber)) | Resolución de referencia: 1720 x 1080"
        $estimate = "No hay una estimación fiable para esta GPU. Busca pruebas de Fortnite con el modelo exacto, resolución 1720×1080 y modo Rendimiento."
        $gpuText = $gpuNames -join " "
        if ($gpuText -match 'RX 7600|RX 6700 XT|RX 6750 XT|RTX 4060|RTX 4060 Ti|RTX 3070') {
            $estimate = "Rango muy aproximado: 180–320 FPS en modo Rendimiento/bajo. La CPU Ryzen 5 5500 puede limitar los FPS en situaciones competitivas; no es garantía."
        } elseif ($gpuText -match 'RX 6600|RX 6650 XT|RX 5700 XT|RTX 3060|RTX 2070|RTX 2060 SUPER') {
            $estimate = "Rango muy aproximado: 150–280 FPS en modo Rendimiento/bajo. En peleas intensas puede bajar bastante; no es garantía."
        } elseif ($gpuText -match 'RX 580|RX 590|RX 570|GTX 1650|GTX 1060|GTX 1660|RX 5500 XT') {
            $estimate = "Rango muy aproximado: 80–180 FPS en modo Rendimiento/bajo. El modelo exacto y la RAM influyen mucho; no es garantía."
        } elseif ($gpuText -match 'RTX 4070|RTX 4080|RTX 4090|RX 7800 XT|RX 7900') {
            $estimate = "Rango muy aproximado: 200–360+ FPS en modo Rendimiento/bajo, pero el Ryzen 5 5500 puede ser el límite. No es garantía."
        } elseif ($gpuText -match 'Intel.*UHD|Radeon.*Graphics|AMD Radeon\(TM\) Graphics|Vega 7|Vega 8') {
            $estimate = "Con gráficos integrados, el rendimiento suele ser mucho menor y depende especialmente de la RAM en doble canal. Prueba 3D resolución baja y modo Rendimiento; no se puede dar un rango fiable solo con el nombre detectado."
        }
        if ($ramGB -lt 12) { $estimate += " Atención: la memoria detectada es limitada para jugar con otras aplicaciones abiertas." }
        elseif ($ramGB -lt 16) { $estimate += " Recomendación: 16 GB de RAM o más ayuda a reducir problemas por falta de memoria, según el equipo." }
        $fpsLabel.Text = $estimate
        $global:K0R1LastAnswer = "K0R1 AURA. Análisis de FPS para Fortnite a 1720 por 1080, modo Rendimiento y ajustes competitivos bajos.`nCPU: $($cpu.Name).`nGPU: $($gpuNames -join ' | ').`nRAM utilizable: $ramGB GB.`n$estimate"
        try { $synth.SpeakAsyncCancelAll(); $null = $synth.SpeakAsync($global:K0R1LastAnswer) } catch {}
    } catch {
        $fpsLabel.Text = "No se pudo leer el hardware. Abre K0R1 de nuevo y vuelve a intentar. Detalle: $($_.Exception.Message)"
        $global:K0R1LastAnswer = $fpsLabel.Text
        try { $synth.SpeakAsyncCancelAll(); $null = $synth.SpeakAsync($global:K0R1LastAnswer) } catch {}
    }
})



# --- ACCIONES REALES DE BOTONES: ajustes explícitos, reversibles y diagnóstico ---
function Show-K0R1Message([string]$title, [string]$message, [System.Windows.MessageBoxImage]$icon = [System.Windows.MessageBoxImage]::Information) {
    [void][System.Windows.MessageBox]::Show($windowMain, $message, $title, [System.Windows.MessageBoxButton]::OK, $icon)
}
function Open-K0R1Url([string]$url) {
    try { Start-Process $url } catch { Show-K0R1Message 'K0R1' "No pude abrir el enlace: $url`n$($_.Exception.Message)" ([System.Windows.MessageBoxImage]::Warning) }
}
function Get-K0R1BackupFolder {
    $folder = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'K0R1_Backups'
    if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
    return $folder
}
function Save-K0R1SettingsBackup {
    $folder = Get-K0R1BackupFolder
    $file = Join-Path $folder ('K0R1-settings-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.json')
    $paths = @('HKCU:\Software\Microsoft\GameBar','HKCU:\System\GameConfigStore')
    $data = foreach ($path in $paths) {
        $item = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
        [pscustomobject]@{ Path=$path; AllowAutoGameMode=$item.AllowAutoGameMode; AutoGameModeEnabled=$item.AutoGameModeEnabled; GameDVR_Enabled=$item.GameDVR_Enabled }
    }
    $data | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $file -Encoding UTF8
    return $file
}
function Set-K0R1GameMode([bool]$enabled) {
    $value = if ($enabled) { 1 } else { 0 }
    New-Item -Path 'HKCU:\Software\Microsoft\GameBar' -Force | Out-Null
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AllowAutoGameMode' -PropertyType DWord -Value $value -Force | Out-Null
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -PropertyType DWord -Value $value -Force | Out-Null
}
function Set-K0R1BackgroundCapture([bool]$enabled) {
    New-Item -Path 'HKCU:\System\GameConfigStore' -Force | Out-Null
    New-ItemProperty -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -PropertyType DWord -Value ([int]$enabled) -Force | Out-Null
    New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Force | Out-Null
    New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -PropertyType DWord -Value ([int]$enabled) -Force | Out-Null
}

# Botón maestro: crea respaldo y aplica solo ajustes de usuario, no toca Defender ni archivos personales.
$windowMain.FindName('BtnMasterAll').Add_Click({
    try {
        $backup = Save-K0R1SettingsBackup
        Set-K0R1GameMode $true
        Set-K0R1BackgroundCapture $false
        Show-K0R1Message 'K0R1 · Optimización aplicada' "Se aplicaron ajustes básicos para jugar:\n• Modo Juego de Windows activado para tu usuario.\n• Captura en segundo plano desactivada.\n• Respaldo guardado en:\n$backup\n\nCierra y vuelve a abrir Fortnite para probar. Esto no garantiza más FPS; compara una partida antes y después."
    } catch { Show-K0R1Message 'No se pudo completar' "Algunos ajustes no se pudieron aplicar. Ejecuta K0R1 normalmente y revisa permisos.\n$($_.Exception.Message)" ([System.Windows.MessageBoxImage]::Warning) }
})
$windowMain.FindName('BtnSystemReport').Add_Click({
    try {
        $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name)
        $gpu = @(Get-CimInstance Win32_VideoController | ForEach-Object Name) -join '; '
        $os = Get-CimInstance Win32_OperatingSystem
        $ram = [math]::Round(([double]$os.TotalVisibleMemorySize / 1MB),1)
        $report = "K0R1 · INFORME DEL SISTEMA`r`nFecha: $(Get-Date)`r`nWindows: $($os.Caption) build $($os.BuildNumber)`r`nCPU: $cpu`r`nGPU: $gpu`r`nRAM utilizable: $ram GB`r`n`r`nLos FPS reales deben medirse dentro del juego."
        $file = Join-Path (Get-K0R1BackupFolder) ('K0R1-SystemReport-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.txt')
        Set-Content -LiteralPath $file -Value $report -Encoding UTF8
        Show-K0R1Message 'Informe creado' "Informe guardado en:`n$file`n`n$report"
    } catch { Show-K0R1Message 'Error de diagnóstico' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) }
})
$windowMain.FindName('BtnRestoreBackup').Add_Click({
    $file = Get-ChildItem (Get-K0R1BackupFolder) -Filter 'K0R1-settings-*.json' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $file) { Show-K0R1Message 'Sin respaldo' 'Todavía no existe respaldo. Pulsa primero Optimizar Windows + crear respaldo.'; return }
    $confirm = [System.Windows.MessageBox]::Show($windowMain, "¿Restaurar los valores de Modo Juego y captura que se guardaron en el respaldo más reciente?`n$($file.FullName)", 'Confirmar restauración', [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) { return }
    try {
        $items = @(Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json)
        foreach ($item in $items) {
            if ($item.Path -eq 'HKCU:\Software\Microsoft\GameBar') {
                foreach ($name in @('AllowAutoGameMode','AutoGameModeEnabled')) { $v = $item.$name; if ($null -ne $v) { Set-ItemProperty -Path $item.Path -Name $name -Type DWord -Value ([int]$v) -Force } }
            }
            if ($item.Path -eq 'HKCU:\System\GameConfigStore' -and $null -ne $item.GameDVR_Enabled) { Set-ItemProperty -Path $item.Path -Name 'GameDVR_Enabled' -Type DWord -Value ([int]$item.GameDVR_Enabled) -Force }
        }
        Show-K0R1Message 'Restauración' 'Se restauraron los valores que estaban presentes en el respaldo. Si un valor no existía antes, Windows puede conservar el valor actual; revisa Ajustes de juego si hace falta.'
    } catch { Show-K0R1Message 'Error al restaurar' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) }
})

$windowMain.FindName('BtnEnableGameMode').Add_Click({ try { $b=Save-K0R1SettingsBackup; Set-K0R1GameMode $true; $windowMain.FindName('LblGameModeStatus').Text = "Modo Juego activado para el usuario. Respaldo: $b. Reinicia Fortnite para comparar." } catch { Show-K0R1Message 'Modo Juego' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnOpenGameSettings').Add_Click({ Start-Process 'ms-settings:gaming-gamemode' })
$windowMain.FindName('BtnProGameMode').Add_Click({ Start-Process 'ms-settings:gaming-gamemode' })
$windowMain.FindName('BtnDisableCapture').Add_Click({ try { $b=Save-K0R1SettingsBackup; Set-K0R1BackgroundCapture $false; $windowMain.FindName('LblCaptureStatus').Text = "Captura en segundo plano desactivada. Respaldo: $b" } catch { Show-K0R1Message 'Captura' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnRestoreCapture').Add_Click({ try { Set-K0R1BackgroundCapture $true; $windowMain.FindName('LblCaptureStatus').Text = 'Captura en segundo plano reactivada para tu usuario.' } catch { Show-K0R1Message 'Captura' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnTweakHighPower').Add_Click({ try { $out = & powercfg.exe /setactive SCHEME_MIN 2>&1; $windowMain.FindName('LblTweakPowerStatus').Text = 'Plan Alto rendimiento solicitado. Puede aumentar consumo/temperatura; mide estabilidad y revierte a Equilibrado si hace falta.' } catch { Show-K0R1Message 'Energía' 'No pude cambiar el plan de energía.' ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnTweakBalancedPower').Add_Click({ try { & powercfg.exe /setactive SCHEME_BALANCED; $windowMain.FindName('LblTweakPowerStatus').Text = 'Plan Equilibrado activado.' } catch { Show-K0R1Message 'Energía' 'No pude cambiar el plan de energía.' ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnStorageHealth').Add_Click({
    $label = $windowMain.FindName('LblStorageHealth')
    try {
        $disks = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop)
        if (-not $disks) { $label.Text = 'No se encontraron unidades locales.'; return }
        $lines = foreach ($d in $disks) {
            $sizeGB = [math]::Round(([double]$d.Size / 1GB), 1)
            $freeGB = [math]::Round(([double]$d.FreeSpace / 1GB), 1)
            $usedPct = if ([double]$d.Size -gt 0) { [math]::Round((1 - ([double]$d.FreeSpace / [double]$d.Size)) * 100) } else { 0 }
            $warning = if ($freeGB -lt 15 -or ($sizeGB -gt 0 -and ($freeGB / $sizeGB) -lt 0.10)) { ' · ESPACIO BAJO' } else { '' }
            "$($d.DeviceID) $freeGB GB libres de $sizeGB GB ($usedPct% usado)$warning"
        }
        $label.Text = ($lines -join "`r`n") + "`r`nConsejo: procura mantener espacio libre para actualizaciones y archivos temporales."
    } catch { $label.Text = 'No se pudieron consultar las unidades: ' + $_.Exception.Message }
})
$windowMain.FindName('BtnProcessReport').Add_Click({
    $label = $windowMain.FindName('LblProcessReport')
    try {
        $top = @(Get-Process -ErrorAction SilentlyContinue | Sort-Object WorkingSet64 -Descending | Select-Object -First 8)
        if (-not $top) { $label.Text = 'No se pudo leer la lista de procesos.'; return }
        $lines = foreach ($proc in $top) {
            $mem = [math]::Round(($proc.WorkingSet64 / 1MB))
            $cpu = if ($null -ne $proc.CPU) { [math]::Round([double]$proc.CPU, 1) } else { 0 }
            "$($proc.ProcessName): $mem MB RAM · $cpu s CPU acumulada"
        }
        $label.Text = ($lines -join "`r`n") + "`r`nNo cierres procesos de Windows que no reconozcas. La CPU mostrada es acumulada, no porcentaje instantáneo."
    } catch { $label.Text = 'No se pudo revisar procesos: ' + $_.Exception.Message }
})
$windowMain.FindName('BtnStartupReport').Add_Click({
    $label = $windowMain.FindName('LblStartupReport')
    try {
        $entries = @()
        $runPaths = @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run')
        foreach ($path in $runPaths) {
            if (Test-Path $path) {
                $props = Get-ItemProperty -LiteralPath $path -ErrorAction SilentlyContinue
                if ($props) {
                    foreach ($prop in $props.PSObject.Properties) {
                        if ($prop.Name -notmatch '^PS(Path|ParentPath|ChildName|Drive|Provider)$' -and $null -ne $prop.Value) { $entries += "• $($prop.Name) — $($prop.Value)" }
                    }
                }
            }
        }
        if ($entries.Count -eq 0) { $label.Text = 'No se encontraron entradas en las claves Run comunes. Otras aplicaciones pueden iniciarse por tareas programadas o carpetas de inicio.' }
        else { $label.Text = ($entries | Select-Object -First 18) -join "`r`n"; if ($entries.Count -gt 18) { $label.Text += "`r`n... y $($entries.Count - 18) entradas más. Usa Administrador de tareas > Aplicaciones de inicio para administrarlas." } }
    } catch { $label.Text = 'No se pudo revisar el inicio: ' + $_.Exception.Message }
})
$windowMain.FindName('BtnDnsTest').Add_Click({
    $label = $windowMain.FindName('LblDnsStatus'); $label.Text = 'Probando resolución DNS…'
    try {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $result = Resolve-DnsName -Name 'epicgames.com' -ErrorAction Stop | Select-Object -First 1
        $sw.Stop()
        $label.Text = "DNS correcto para epicgames.com · consulta completada en $($sw.ElapsedMilliseconds) ms · tipo $($result.Type). Esto mide resolución DNS, no el ping del juego."
    } catch { $label.Text = 'Falló la consulta DNS de epicgames.com. Comprueba internet o el DNS configurado. Detalle: ' + $_.Exception.Message }
})
$windowMain.FindName('BtnDnsFlush').Add_Click({
    $confirm = [System.Windows.MessageBox]::Show($windowMain, 'Esto solo vacía la caché DNS local de Windows. No cambia el servidor DNS ni garantiza menor ping. ¿Continuar?', 'Vaciar caché DNS', [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) { return }
    try { $out = & ipconfig.exe /flushdns 2>&1; $windowMain.FindName('LblDnsStatus').Text = (($out | Out-String).Trim()); if ($LASTEXITCODE -ne 0) { $windowMain.FindName('LblDnsStatus').Text += "`r`nWindows no confirmó el vaciado; prueba desde una consola normal." } }
    catch { $windowMain.FindName('LblDnsStatus').Text = 'No se pudo vaciar la caché DNS: ' + $_.Exception.Message }
})
$windowMain.FindName('BtnOpenGraphicsSettings').Add_Click({ try { Start-Process 'ms-settings:display-graphics' } catch { Show-K0R1Message 'Gráficos' 'No se pudo abrir Ajustes de gráficos de Windows.' ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnPowerPlan').Add_Click({ try { & powercfg.exe /setactive SCHEME_MIN; $windowMain.FindName('LblPowerStatus').Text = 'Se solicitó Alto rendimiento. Puede aumentar consumo y temperatura; comprueba estabilidad.' } catch { Show-K0R1Message 'Energía' 'No se pudo activar Alto rendimiento.' ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnPowerStatus').Add_Click({ try { $p = (& powercfg.exe /getactivescheme 2>&1) -join ' '; $windowMain.FindName('LblPowerStatus').Text = "Plan activo: $p" } catch { $windowMain.FindName('LblPowerStatus').Text = 'No se pudo consultar el plan de energía.' } })
$windowMain.FindName('BtnOpenStartup').Add_Click({ Start-Process 'taskmgr.exe' })
$windowMain.FindName('BtnOpenIso').Add_Click({ Open-K0R1Url 'https://www.microsoft.com/software-download/windows11' })
$windowMain.FindName('BtnDriverNvidia').Add_Click({ Open-K0R1Url 'https://www.nvidia.com/Download/index.aspx' })
$windowMain.FindName('BtnDriverAmd').Add_Click({ Open-K0R1Url 'https://www.amd.com/en/support/download/drivers.html' })
$windowMain.FindName('BtnDriverIntel').Add_Click({ Open-K0R1Url 'https://www.intel.com/content/www/us/en/download-center/home.html' })
$windowMain.FindName('BtnProMsInfo').Add_Click({ Start-Process 'msinfo32.exe' })
$windowMain.FindName('BtnProRecovery').Add_Click({ Start-Process 'ms-settings:recovery' })
$windowMain.FindName('BtnProPower').Add_Click({ Start-Process 'powercfg.cpl' })
$windowMain.FindName('BtnProDeviceMgr').Add_Click({ Start-Process 'devmgmt.msc' })
$windowMain.FindName('BtnPlanUtility').Add_Click({ Show-K0R1Message 'Planes K0R1' 'Este botón es informativo: no procesa pagos ni activa planes. No envíes dinero desde esta demo.' })
$windowMain.FindName('BtnPlanExtreme').Add_Click({ Show-K0R1Message 'Planes K0R1' 'Este botón es informativo: no procesa pagos ni activa planes. No envíes dinero desde esta demo.' })
$windowMain.FindName('BtnPlanSupreme').Add_Click({ Show-K0R1Message 'Planes K0R1' 'Este botón es informativo: no procesa pagos ni activa planes. No envíes dinero desde esta demo.' })
$windowMain.FindName('BtnCompraGratis').Add_Click({ Show-K0R1Message 'Plan gratis' 'El panel local no requiere pago. Esta demo no valida códigos ni cobra.' })
foreach ($name in @('BtnCompra9','BtnCompra25','BtnCompra35','BtnCompraWhatsApp','BtnCompraCorreo')) {
    $control = $windowMain.FindName($name)
    if ($null -ne $control) { $control.Add_Click({ Show-K0R1Message 'Compras desactivadas' 'La compra no está conectada a un sistema real de pagos ni a un contacto verificado. No transfieras dinero desde esta demo.' }.GetNewClosure()) }
}
$windowMain.FindName('BtnNetworkTest').Add_Click({
    $label = $windowMain.FindName('LblNetworkResult'); $label.Text = 'Probando conexión con 1.1.1.1…'
    try { $r = Test-Connection -ComputerName '1.1.1.1' -Count 4 -ErrorAction Stop; $avg = [math]::Round((($r | Measure-Object -Property ResponseTime -Average).Average),1); $label.Text = "Respuesta media aproximada: $avg ms (ICMP). Esto no equivale exactamente al ping de Fortnite." }
    catch { $label.Text = 'No se obtuvo respuesta ICMP. Tu red puede bloquear esta prueba; no significa necesariamente que no tengas internet.' }
})
$windowMain.FindName('BtnOpenWebsite').Add_Click({
    Start-Process 'https://andresccccccc6-ops.github.io/K0R1-AURA-JARVIS2/'
})
$windowMain.FindName('BtnWebFeatures').Add_Click({
    $windowMain.FindName('ViewTweaks').Visibility = 'Visible'
    $windowMain.FindName('ViewInicio').Visibility = 'Collapsed'
    $windowMain.FindName('NavTweaks').RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
})
$windowMain.FindName('BtnLanScan').Add_Click({
    $label = $windowMain.FindName('LblNetworkResult')
    $label.Text = 'Analizando adaptadores activos y equipos de la red local…'
    try {
        $cfg = Get-NetIPConfiguration -ErrorAction Stop |
            Where-Object { $_.IPv4Address -and $_.NetAdapter.Status -eq 'Up' -and $_.IPv4DefaultGateway } |
            Select-Object -First 1
        if (-not $cfg) { throw 'No encontré un adaptador IPv4 activo con puerta de enlace.' }
        $ip = [string]$cfg.IPv4Address.IPAddress
        $prefix = [int]$cfg.IPv4Address.PrefixLength
        if ($prefix -lt 16 -or $prefix -gt 30) {
            $label.Text = "Tu IP es $ip/$prefix. La máscara es demasiado amplia o especial para un escaneo seguro automático. Revisa el router para ver los dispositivos conectados."
            return
        }
        $parts = $ip.Split('.') | ForEach-Object { [int]$_ }
        $ipInt = ([uint32]$parts[0] -shl 24) -bor ([uint32]$parts[1] -shl 16) -bor ([uint32]$parts[2] -shl 8) -bor [uint32]$parts[3]
        $mask = [uint32](([uint64]0xFFFFFFFF -shl (32 - $prefix)) -band 0xFFFFFFFF)
        $network = $ipInt -band $mask
        $broadcast = $network -bor ([uint32]0xFFFFFFFF -bxor $mask)
        $hostCount = [int]($broadcast - $network - 1)
        if ($hostCount -gt 512) { throw "La red contiene $hostCount direcciones posibles; por seguridad, este escaneo está limitado a 512." }

        $found = New-Object System.Collections.Generic.List[string]
        $found.Add("Este equipo: $ip")
        $found.Add("Adaptador: $($cfg.InterfaceAlias) · puerta de enlace: $($cfg.IPv4DefaultGateway.NextHop)")
        $found.Add("Buscando respuestas en $ip/$prefix (hasta $hostCount direcciones)…")
        for ($n = [uint64]($network + 1); $n -lt [uint64]$broadcast; $n++) {
            if ($n -eq [uint64]$ipInt) { continue }
            $a = [int](($n -shr 24) -band 255); $b = [int](($n -shr 16) -band 255)
            $c = [int](($n -shr 8) -band 255); $d = [int]($n -band 255)
            $target = "$a.$b.$c.$d"
            try {
                $reply = Test-Connection -ComputerName $target -Count 1 -Quiet -ErrorAction SilentlyContinue
                if ($reply) {
                    $name = ''
                    try { $name = [System.Net.Dns]::GetHostEntry($target).HostName } catch {}
                    if ($name) { $found.Add("$target  ·  $name") } else { $found.Add($target) }
                }
            } catch {}
        }
        try {
            $neighbors = Get-NetNeighbor -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                Where-Object { $_.InterfaceIndex -eq $cfg.InterfaceIndex -and $_.State -notin @('Unreachable','Incomplete') -and $_.IPAddress -ne $ip }
            foreach ($neighbor in $neighbors) {
                $entry = "$($neighbor.IPAddress)  ·  MAC $($neighbor.LinkLayerAddress)  ·  $($neighbor.State)"
                if (-not ($found -contains $entry)) { $found.Add($entry) }
            }
        } catch {}
        $label.Text = ($found -join "`r`n")
        $label.Text += "`r`n`r`nNota: los dispositivos que bloquean ICMP pueden no responder. Para una lista completa, consulta la app/página del router."
    } catch {
        $label.Text = "No se pudo descubrir la red local: $($_.Exception.Message)"
    }
})
$windowMain.FindName('BtnDetectGpu').Add_Click({
    try { $g = @(Get-CimInstance Win32_VideoController | ForEach-Object Name); $windowMain.FindName('LblDetectedGpu').Text = ($g -join ' | '); $windowMain.FindName('LblDriverAdvice').Text = 'Descarga el controlador únicamente del fabricante correspondiente y reinicia si el instalador lo solicita.' }
    catch { $windowMain.FindName('LblDetectedGpu').Text = 'No se pudo detectar la GPU.' }
})
$windowMain.FindName('BtnFortnitePriority').Add_Click({
    $games = @(Get-Process -Name 'FortniteClient-Win64-Shipping' -ErrorAction SilentlyContinue)
    if (-not $games) { $windowMain.FindName('LblFortniteFiles').Text = 'Fortnite no está abierto. Abre el juego y vuelve a pulsar; no se cambia la prioridad de otros procesos.'; return }
    try { foreach ($g in $games) { $g.PriorityClass = 'AboveNormal' }; $windowMain.FindName('LblFortniteFiles').Text = 'Prioridad AboveNormal aplicada a Fortnite mientras está abierto. Es temporal y no garantiza más FPS.' }
    catch { $windowMain.FindName('LblFortniteFiles').Text = 'Windows no permitió cambiar la prioridad. El juego sigue funcionando normalmente.' }
})
$windowMain.FindName('BtnFortniteFiles').Add_Click({
    $paths = @((Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\WindowsClient'),(Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\Windows'))
    $dir = $paths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $dir) { $windowMain.FindName('LblFortniteFiles').Text = 'No encontré la carpeta de configuración estándar. Comprueba que Fortnite se haya ejecutado al menos una vez.'; return }
    $cfg = Join-Path $dir 'GameUserSettings.ini'
    if (Test-Path $cfg) { $backup = Join-Path (Get-K0R1BackupFolder) ('GameUserSettings-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.ini.bak'); Copy-Item -LiteralPath $cfg -Destination $backup -Force; $windowMain.FindName('LblFortniteFiles').Text = "Configuración encontrada: $cfg`nRespaldo creado: $backup" }
    else { $windowMain.FindName('LblFortniteFiles').Text = "Carpeta encontrada: $dir, pero GameUserSettings.ini aún no existe." }
})
$windowMain.FindName('BtnFortniteOpenConfig').Add_Click({ $paths = @((Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\WindowsClient'),(Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\Windows')); $dir = $paths | Where-Object { Test-Path $_ } | Select-Object -First 1; if ($dir) { Start-Process explorer.exe $dir } else { Show-K0R1Message 'Fortnite' 'No encontré la carpeta de configuración estándar de Fortnite.' } })
$windowMain.FindName('BtnCreateBackup').Add_Click({ try { $f=Save-K0R1SettingsBackup; Show-K0R1Message 'Respaldo creado' "Se guardó el respaldo en:`n$f" } catch { Show-K0R1Message 'Respaldo' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) } })
$windowMain.FindName('BtnCleanTemp').Add_Click({
    $confirm = [System.Windows.MessageBox]::Show($windowMain, 'Se eliminarán solo archivos de la carpeta temporal de tu usuario. Los archivos en uso se omitirán. ¿Continuar?', 'Confirmar limpieza', [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    if ($confirm -ne [System.Windows.MessageBoxResult]::Yes) { return }
    try { $items = @(Get-ChildItem -LiteralPath $env:TEMP -Force -ErrorAction SilentlyContinue); $count=0; foreach ($item in $items) { try { Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction Stop; $count++ } catch {} }; Show-K0R1Message 'Limpieza completada' "Se limpiaron $count elementos temporales. Los archivos bloqueados se omitieron; no se tocaron Descargas ni documentos." }
    catch { Show-K0R1Message 'Limpieza' 'No se pudo completar la limpieza.' ([System.Windows.MessageBoxImage]::Warning) }
})
$windowMain.FindName('BtnApplyRgb').Add_Click({
    $selected = $windowMain.FindName('CmbRgbColors').SelectedItem
    $name = if ($selected) { [string]$selected.Content } else { 'Morado K0R1' }
    $openRgb = Get-Command 'OpenRGB.exe' -ErrorAction SilentlyContinue
    $candidates = @(
        (Join-Path $env:ProgramFiles 'OpenRGB\OpenRGB.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'OpenRGB\OpenRGB.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\OpenRGB\OpenRGB.exe')
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }
    $rgbExe = if ($openRgb) { $openRgb.Source } elseif ($candidates) { $candidates | Select-Object -First 1 } else { $null }
    if ($rgbExe) {
        try { Start-Process -FilePath $rgbExe; Show-K0R1Message 'Control RGB compatible' "Se abrió OpenRGB. Selecciona el dispositivo y aplica el perfil '$name' dentro de OpenRGB. K0R1 no fuerza cambios sin conocer el controlador." }
        catch { Show-K0R1Message 'RGB' "No pude abrir OpenRGB: $($_.Exception.Message)" ([System.Windows.MessageBoxImage]::Warning) }
    } else {
        Show-K0R1Message 'RGB físico no detectado' "Perfil seleccionado: $name`nK0R1 no puede cambiar físicamente los ventiladores de forma universal. Instala OpenRGB desde su sitio oficial si tu placa/controlador aparece como compatible, o usa el programa del fabricante (Gigabyte Control Center/RGB Fusion, ASUS Armoury Crate, MSI Center/Mystic Light, Corsair iCUE). No instales controladores RGB de sitios desconocidos."
        Start-Process 'https://openrgb.org/'
    }
})

$btnSecurityAudit = $windowMain.FindName('BtnSecurityAudit')
if ($btnSecurityAudit) { $btnSecurityAudit.Add_Click({ try { Show-K0R1Message 'Auditoría de seguridad (solo lectura)' (Get-K0R1SecuritySummary) } catch { Show-K0R1Message 'Auditoría' $_.Exception.Message ([System.Windows.MessageBoxImage]::Warning) } }) }

$btnStartupSettings = $windowMain.FindName('BtnOpenStartupSettings')
if ($btnStartupSettings) { $btnStartupSettings.Add_Click({ try { Start-Process 'ms-settings:startupapps' } catch { Show-K0R1Message 'Inicio de Windows' 'No se pudo abrir Configuración.' ([System.Windows.MessageBoxImage]::Warning) } }) }
$btnWindowsSecurity = $windowMain.FindName('BtnOpenWindowsSecurity')
if ($btnWindowsSecurity) { $btnWindowsSecurity.Add_Click({ try { Start-Process 'windowsdefender:' } catch { try { Start-Process 'ms-settings:windowsdefender' } catch { Show-K0R1Message 'Seguridad' 'Abre Seguridad de Windows desde el menú Inicio.' ([System.Windows.MessageBoxImage]::Warning) } } }) }

# --- SEGURIDAD LOCAL ADICIONAL (DPAPI) ---
# Utilidad para futuros datos locales sensibles. DPAPI CurrentUser liga el archivo al usuario
# de Windows; no sustituye validación de licencias en servidor ni protege el código fuente.
function Protect-K0R1LocalText([string]$PlainText, [string]$FilePath) {
    if ([string]::IsNullOrEmpty($PlainText)) { throw 'No hay contenido que proteger.' }
    $secureBytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
    $protected = [System.Security.Cryptography.ProtectedData]::Protect(
        $secureBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    $directory = Split-Path -Parent $FilePath
    if ($directory -and -not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    [System.IO.File]::WriteAllBytes($FilePath, $protected)
}
function Unprotect-K0R1LocalText([string]$FilePath) {
    if (-not (Test-Path -LiteralPath $FilePath)) { throw 'No existe el archivo protegido.' }
    $protected = [System.IO.File]::ReadAllBytes($FilePath)
    $plain = [System.Security.Cryptography.ProtectedData]::Unprotect(
        $protected, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    [System.Text.Encoding]::UTF8.GetString($plain)
}

# Diagnóstico de seguridad de solo lectura: no desactiva Defender ni el firewall.
function Get-K0R1SecuritySummary {
    $items = [System.Collections.Generic.List[string]]::new()
    $items.Add("PowerShell: $($PSVersionTable.PSVersion)")
    $items.Add("Windows: $([Environment]::OSVersion.VersionString)")
    try {
        $secureBoot = Confirm-SecureBootUEFI -ErrorAction Stop
        $items.Add("Secure Boot: $secureBoot")
    } catch { $items.Add('Secure Boot: no disponible en este equipo/firmware') }
    try {
        $mp = Get-MpComputerStatus -ErrorAction Stop
        $items.Add("Microsoft Defender activo: $($mp.AntivirusEnabled)")
        $items.Add("Protección en tiempo real: $($mp.RealTimeProtectionEnabled)")
    } catch { $items.Add('Defender: estado no disponible (permisos o proveedor no disponible)') }
    try {
        $fw = Get-NetFirewallProfile -ErrorAction Stop
        $enabled = @($fw | Where-Object { $_.Enabled }).Count
        $items.Add("Perfiles de firewall activos: $enabled de $(@($fw).Count)")
    } catch { $items.Add('Firewall: estado no disponible') }
    return ($items -join "`r`n")
}

# --- K0R1 OPTIMIZER: perfiles seguros inspirados en prácticas públicas de optimización ---
# No replica código de terceros. Cada acción es explícita y reversible.
function Get-K0R1OptimizationChecklist {
    [pscustomobject]@{
        Titulo = 'Perfil competitivo seguro'
        Pasos = @(
            'Crear un punto de restauración o respaldo antes de cambios del sistema.',
            'Revisar aplicaciones de inicio y deshabilitar solo las que el usuario reconoce y no necesita.',
            'Activar Modo Juego de Windows y desactivar capturas en segundo plano solo si no se usan.',
            'Seleccionar el plan de energía adecuado al equipo; vigilar consumo y temperatura.',
            'Actualizar el driver desde AMD, NVIDIA o Intel oficiales.',
            'Medir FPS medios, 1% lows, ping y temperaturas antes y después en la misma escena.',
            'No desactivar Defender/firewall, no aplicar debloat masivo, ni cambiar voltajes automáticamente.'
        )
    }
}

# --- MONITOR DE PORCENTAJES: CPU/RAM REALES; GPU SOLO SI HAY CONTADOR DISPONIBLE ---
function Update-K0R1Metrics {
    try {
        $cpuInfo = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1
        if ($null -ne $cpuInfo -and $null -ne $cpuInfo.LoadPercentage) {
            $cpuPercent = [int][math]::Min(100, [math]::Max(0, $cpuInfo.LoadPercentage))
            $windowMain.FindName("LblCpuVal").Text = "$cpuPercent%"
            $windowMain.FindName("BarCpu").Value = $cpuPercent
        } else {
            $windowMain.FindName("LblCpuVal").Text = "N/D"
            $windowMain.FindName("BarCpu").Value = 0
        }
    } catch {
        $windowMain.FindName("LblCpuVal").Text = "N/D"
        $windowMain.FindName("BarCpu").Value = 0
    }
    try {
        $osInfo = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $totalKB = [double]$osInfo.TotalVisibleMemorySize
        $freeKB = [double]$osInfo.FreePhysicalMemory
        if ($totalKB -gt 0) {
            $ramPercent = [int][math]::Min(100, [math]::Max(0, [math]::Round((($totalKB - $freeKB) / $totalKB) * 100)))
            $windowMain.FindName("LblRamVal").Text = "$ramPercent%"
            $windowMain.FindName("BarRam").Value = $ramPercent
        }
    } catch {
        $windowMain.FindName("LblRamVal").Text = "N/D"
        $windowMain.FindName("BarRam").Value = 0
    }
    # Intenta obtener uso de motores GPU (3D) reportado por Windows. El máximo por motor no equivale necesariamente a carga total de GPU; si no hay contador, muestra N/D.
    try {
        $gpuCounters = Get-Counter -ListSet "GPU Engine" -ErrorAction Stop
        $gpuSamples = Get-Counter -Counter '\GPU Engine(*)\Utilization Percentage' -ErrorAction Stop
        $threeD = @($gpuSamples.CounterSamples | Where-Object { $_.Path -match 'engtype_3D' -and $_.CookedValue -ge 0 })
        if ($threeD.Count -gt 0) {
            $gpuPercent = [int][math]::Min(100, [math]::Max(0, [math]::Round((($threeD | Measure-Object -Property CookedValue -Maximum).Maximum))))
            $windowMain.FindName("LblGpuVal").Text = "$gpuPercent%"
            $windowMain.FindName("BarGpu").Value = $gpuPercent
        } else { $windowMain.FindName("LblGpuVal").Text = "N/D"; $windowMain.FindName("BarGpu").Value = 0 }
    } catch {
        $windowMain.FindName("LblGpuVal").Text = "N/D"
        $windowMain.FindName("BarGpu").Value = 0
    }
    # La zona térmica ACPI no existe en todos los equipos y puede informar valores ficticios.
    # Solo mostramos el dato si el proveedor entrega una lectura plausible; no se convierte a °C a ciegas.
    try {
        $tempLabel = $windowMain.FindName("LblTempVal")
        if ($tempLabel) {
            $thermal = @(Get-CimInstance -Namespace 'root/wmi' -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop | Where-Object { $_.CurrentTemperature -gt 0 })
            $celsius = @($thermal | ForEach-Object { ([double]$_.CurrentTemperature / 10.0) - 273.15 } | Where-Object { $_ -ge 10 -and $_ -le 110 })
            if ($celsius.Count -gt 0) {
                $maxTemp = [int][math]::Round(($celsius | Measure-Object -Maximum).Maximum)
                $tempLabel.Text = "Temperatura ACPI: $maxTemp °C (sensor de placa; no siempre es CPU/GPU)"
            } else { $tempLabel.Text = 'Temperatura CPU/GPU: N/D · sensor compatible no disponible' }
        }
    } catch {
        $tempLabel = $windowMain.FindName("LblTempVal")
        if ($tempLabel) { $tempLabel.Text = 'Temperatura CPU/GPU: N/D · requiere sensor compatible' }
    }
}
Update-K0R1Metrics
$metricTimer = New-Object System.Windows.Threading.DispatcherTimer
$metricTimer.Interval = [TimeSpan]::FromSeconds(3)
$metricTimer.Add_Tick({ Update-K0R1Metrics })
$metricTimer.Start()

# Saludo inicial visual en la consola del asistente; el audio se reproduce tras iniciar sesión.
$windowMain.ShowDialog() | Out-Null
$metricTimer.Stop()
try { $synth.Dispose() } catch {}
