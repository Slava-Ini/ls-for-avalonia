set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

windows_install_dir := env_var_or_default("LOCALAPPDATA", "") / "avalonia-ls"

build:
    dotnet build src/AvaloniaLSP/AvaloniaLanguageServer --output bin/lsp
    dotnet build src/SolutionParser/SolutionParser.csproj --output bin/solution-parser
    dotnet build src/XamlStyler/src/XamlStyler.Console/XamlStyler.Console.csproj --output bin/xaml-styler
    dotnet build src/AvaloniaPreview --output bin/avalonia-preview

[linux]
install: build
    mkdir -p ~/.local/share/avalonia-ls
    cp bin/* ~/.local/share/avalonia-ls -r
    echo -e "#!/usr/bin/env bash\n exec ~/.local/share/avalonia-ls/xaml-styler/xstyler \"\$@\"" > ~/.local/bin/xaml-styler
    chmod +x ~/.local/bin/xaml-styler
    
    echo -e "#!/usr/bin/env bash\n exec ~/.local/share/avalonia-ls/lsp/AvaloniaLanguageServer \"\$@\"" > ~/.local/bin/avalonia-ls
    chmod +x ~/.local/bin/avalonia-ls
    
    echo -e "#!/usr/bin/env bash\n exec ~/.local/share/avalonia-ls/solution-parser/SolutionParser \"\$@\"" > ~/.local/bin/avalonia-solution-parser
    chmod +x ~/.local/bin/avalonia-solution-parser

    echo -e "#!/usr/bin/env bash\n exec ~/.local/share/avalonia-ls/avalonia-preview/AvaloniaPreview \"\$@\"" > ~/.local/bin/avalonia-preview
    chmod +x ~/.local/bin/avalonia-preview

    @echo "INSTALLATION COMPLETE!"

[windows]
install:
    dotnet publish src/AvaloniaLSP/AvaloniaLanguageServer -c Release -p:PublishSingleFile=true --output "{{ windows_install_dir }}"
    dotnet publish src/SolutionParser/SolutionParser.csproj -c Release -p:PublishSingleFile=true --output "{{ windows_install_dir }}"
    dotnet publish src/XamlStyler/src/XamlStyler.Console/XamlStyler.Console.csproj -c Release -f net9.0 -p:PublishSingleFile=true --output "{{ windows_install_dir }}"
    dotnet publish src/AvaloniaPreview -c Release -p:PublishSingleFile=true --output "{{ windows_install_dir }}"

    Rename-Item -Path "{{ windows_install_dir }}\AvaloniaLanguageServer.exe" -NewName "avalonia-ls.exe" -Force
    Rename-Item -Path "{{ windows_install_dir }}\SolutionParser.exe" -NewName "avalonia-solution-parser.exe" -Force
    Rename-Item -Path "{{ windows_install_dir }}\xstyler.exe" -NewName "xaml-styler.exe" -Force -ErrorAction SilentlyContinue
    Rename-Item -Path "{{ windows_install_dir }}\AvaloniaPreview.exe" -NewName "avalonia-preview.exe" -Force

    @echo "INSTALLATION COMPLETE!"
    @echo "Add '{{ windows_install_dir }}' to your PATH to use the tools from anywhere."


[linux]
uninstall:
    rm -rf ~/.local/share/avalonia-ls
    rm ~/.local/bin/xaml-styler ~/.local/bin/avalonia-ls ~/.local/bin/avalonia-solution-parser ~/.local/bin/avalonia-preview
    echo "UNINSTALLATION COMPLETE"

[windows]
uninstall:
    #!powershell.exe
    if (Test-Path "{{ windows_install_dir }}") {
        Remove-Item -Path "{{ windows_install_dir }}" -Recurse -Force
    }
    echo "UNINSTALLATION COMPLETE"
    
