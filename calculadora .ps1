Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Calculadora" Height="500" Width="320" Background="#121212"
    WindowStartupLocation="CenterScreen" ResizeMode="NoResize">
    <Grid Margin="15">
        <Grid.RowDefinitions>
            <RowDefinition Height="100"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <Border Background="#1E1E1E" CornerRadius="15" Margin="0,0,0,15">
            <TextBox Name="txt" Foreground="White" FontSize="45" Background="Transparent" 
                     BorderThickness="0" TextAlignment="Right" IsReadOnly="True" 
                     Text="0" VerticalContentAlignment="Center" Padding="10"/>
        </Border>

        <UniformGrid Name="btns" Grid.Row="1" Rows="5" Columns="4">
            <UniformGrid.Resources>
                <Style TargetType="Button">
                    <Setter Property="Margin" Value="4"/>
                    <Setter Property="FontSize" Value="20"/>
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="Background" Value="#2D2D2D"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}" CornerRadius="10">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </UniformGrid.Resources>

            <Button Content="C" Background="#E74C3C"/>
            <Button Content="(" Background="#444444"/>
            <Button Content=")" Background="#444444"/>
            <Button Content="/" Background="#F39C12"/>
            <Button Content="7"/> <Button Content="8"/> <Button Content="9"/> <Button Content="*" Background="#F39C12"/>
            <Button Content="4"/> <Button Content="5"/> <Button Content="6"/> <Button Content="-" Background="#F39C12"/>
            <Button Content="1"/> <Button Content="2"/> <Button Content="3"/> <Button Content="+" Background="#F39C12"/>
            <Button Content="0"/> <Button Content="."/> <Button Content="=" Background="#27AE60"/>
        </UniformGrid>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$v = [Windows.Markup.XamlReader]::Load($reader)

$script:op = ""
$p = $v.FindName("txt")
$g = $v.FindName("btns")

foreach ($b in $g.Children) {
    $b.Add_Click({
        $t = $_.Source.Content.ToString()
        if ($t -eq "C") {
            $script:op = ""
            $p.Text = "0"
        }
        elseif ($t -eq "=") {
            try {
                $res = Invoke-Expression $script:op
                $p.Text = [math]::Round($res, 4)
                $script:op = [string]$p.Text
            } catch {
                $p.Text = "Error"
                $script:op = ""
            }
        }
        else {
            if ($p.Text -eq "0") { $script:op = "" }
            $script:op += $t
            $p.Text = $script:op
        }
    })
}

$v.ShowDialog() | Out-Null