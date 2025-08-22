# 🖥️ HiDPI Configurator - Interface Gráfica

Uma interface gráfica moderna e elegante para configurar HiDPI no macOS, construída com SwiftUI e design inspirado no macOS 26.

## ✨ Características

### 🎨 Interface Moderna
- **Design nativo do macOS** - Interface que se integra perfeitamente ao sistema
- **Material Design** - Efeitos visuais modernos e responsivos
- **Sidebar Navigation** - Navegação intuitiva com ícones do sistema
- **Dark Mode Support** - Suporte completo ao modo escuro

### 🚀 Funcionalidades Principais

#### 📊 Dashboard
- **Status Cards** - Visão geral do sistema, HiDPI e backups
- **Quick Actions** - Ações rápidas para configuração automática
- **Recent Activity** - Histórico de atividades recentes
- **Real-time Updates** - Atualizações em tempo real

#### ⚙️ Configuração de Monitor
- **Auto-detection** - Detecta automaticamente o hardware
- **Resolution Presets** - Presets otimizados para diferentes resoluções
- **Icon Selection** - Escolha de ícones para diferentes tipos de monitor
- **Custom Names** - Nomes personalizados para monitores

#### 🔧 Diagnósticos
- **System Health Check** - Verificação completa do sistema
- **SIP Status** - Status do System Integrity Protection
- **Network Connectivity** - Verificação de conectividade
- **Disk Space** - Monitoramento de espaço em disco

#### 💾 Backup & Restore
- **Automated Backups** - Backups automáticos com metadados
- **Quick Restore** - Restauração rápida de configurações
- **Backup History** - Histórico completo de backups
- **Metadata Tracking** - Rastreamento detalhado de configurações

## 🛠️ Instalação

### Pré-requisitos
- macOS 14.0 ou superior
- Xcode 15.0 ou superior (para compilação)
- Script `hidpi.sh` na mesma pasta

### Compilação

1. **Clone o repositório:**
   ```bash
   git clone <repository-url>
   cd one-key-hidpi
   ```

2. **Execute o script de build:**
   ```bash
   ./build_app.sh
   ```

3. **Configure permissões:**
   ```bash
   chmod +x hidpi.sh
   ```

4. **Execute o aplicativo:**
   ```bash
   open "HiDPI Configurator.app"
   ```

### Permissões Necessárias

O aplicativo pode precisar de permissões adicionais:

1. **Acessibilidade:**
   - Vá em Preferências do Sistema > Privacidade & Segurança > Acessibilidade
   - Adicione "HiDPI Configurator" à lista

2. **Execução de Scripts:**
   - O app executa o script `hidpi.sh` para operações do sistema
   - Certifique-se de que o script tem permissões de execução

## 🎯 Como Usar

### Primeira Execução

1. **Abra o aplicativo** - A interface carregará automaticamente
2. **Verifique o Dashboard** - Confirme o status do sistema
3. **Execute Diagnósticos** - Verifique se tudo está funcionando
4. **Configure seu Monitor** - Use a configuração automática ou manual

### Configuração Automática

1. **Clique em "Auto Configure"** no Dashboard
2. **Confirme a configuração** sugerida
3. **Aguarde a aplicação** das configurações
4. **Reinicie o Mac** para aplicar as mudanças

### Configuração Manual

1. **Vá para "Monitor Configuration"**
2. **Selecione a resolução** desejada
3. **Escolha o ícone** apropriado
4. **Digite um nome personalizado** (opcional)
5. **Clique em "Apply Configuration"**

### Backup e Restore

1. **Backups automáticos** são criados antes de cada mudança
2. **Acesse "Backup & Restore"** para gerenciar backups
3. **Use "Quick Restore"** para restaurar rapidamente
4. **Verifique metadados** para informações detalhadas

## 🔧 Integração com Script

O aplicativo se integra perfeitamente com o script `hidpi.sh`:

### Argumentos Suportados
- `--info` - Informações do sistema em JSON
- `--auto` - Configuração automática
- `--diagnostics` - Execução de diagnósticos
- `--configure` - Configuração manual com parâmetros
- `--reset` - Reset das configurações

### Comunicação
- **Process Communication** - Comunicação via Process/NSProcess
- **JSON Output** - Saída estruturada para parsing
- **Error Handling** - Tratamento robusto de erros
- **Async Operations** - Operações assíncronas para não bloquear a UI

## 🎨 Design System

### Cores
- **Primary Blue** - #007AFF (ações principais)
- **Success Green** - #34C759 (sucessos)
- **Warning Orange** - #FF9500 (avisos)
- **Error Red** - #FF3B30 (erros)
- **Background** - .regularMaterial (fundo adaptativo)

### Tipografia
- **Large Title** - Títulos principais
- **Title 2** - Subtítulos
- **Headline** - Cabeçalhos de seção
- **Subheadline** - Texto secundário
- **Caption** - Texto pequeno

### Componentes
- **Status Cards** - Cards informativos com ícones
- **Action Buttons** - Botões de ação com descrições
- **Icon Selection** - Seleção visual de ícones
- **Activity Rows** - Linhas de atividade com timestamps

## 🚀 Recursos Avançados

### Multi-language Support
- **6 Idiomas** - Inglês, Português, Espanhol, Francês, Chinês, Ucraniano
- **Auto-detection** - Detecta automaticamente o idioma do sistema
- **Localized UI** - Interface completamente localizada

### Hardware Detection
- **Apple Silicon** - Suporte completo para Macs com Apple Silicon
- **Intel Macs** - Compatibilidade com Macs Intel
- **External Displays** - Suporte para monitores externos
- **Notebook Models** - Detecção específica de modelos de notebook

### Performance
- **Async Operations** - Operações não-bloqueantes
- **Background Processing** - Processamento em background
- **Memory Management** - Gerenciamento eficiente de memória
- **Error Recovery** - Recuperação automática de erros

## 🔒 Segurança

### Permissões
- **Minimal Permissions** - Permissões mínimas necessárias
- **User Consent** - Consentimento explícito do usuário
- **Secure Execution** - Execução segura de scripts
- **Data Protection** - Proteção de dados sensíveis

### Validação
- **Input Validation** - Validação de entrada do usuário
- **System Checks** - Verificações de segurança do sistema
- **Error Handling** - Tratamento robusto de erros
- **Logging** - Logging detalhado para debugging

## 📱 Compatibilidade

### Sistemas Suportados
- **macOS 14.0+** - Suporte completo
- **Apple Silicon** - Otimizado para M1/M2/M3
- **Intel Macs** - Compatibilidade total
- **Retina Displays** - Suporte nativo para displays Retina

### Resoluções Suportadas
- **1920x1080** - Full HD
- **2560x1440** - 2K
- **3840x2160** - 4K
- **1366x768** - HD
- **2560x1600** - WQXGA
- **3024x1964** - MacBook Pro 14"
- **3456x2234** - MacBook Pro 16"
- **3440x1440** - Ultrawide

## 🐛 Troubleshooting

### Problemas Comuns

1. **App não abre:**
   - Verifique permissões de acessibilidade
   - Confirme que o Xcode está instalado
   - Verifique se o script `hidpi.sh` existe

2. **Erro de permissão:**
   - Vá em Preferências do Sistema > Privacidade & Segurança
   - Adicione o app às permissões necessárias

3. **Configuração não aplica:**
   - Execute diagnósticos primeiro
   - Verifique se o SIP está habilitado
   - Confirme que há espaço em disco

4. **Interface não responde:**
   - Verifique se há operações em background
   - Aguarde a conclusão das operações
   - Reinicie o app se necessário

### Logs e Debugging

O aplicativo gera logs detalhados:
- **Console.app** - Logs do sistema
- **Activity Monitor** - Monitoramento de processos
- **Script Output** - Saída do script bash

## 🤝 Contribuição

### Desenvolvimento

1. **Fork o projeto**
2. **Crie uma branch** para sua feature
3. **Desenvolva** seguindo as guidelines
4. **Teste** extensivamente
5. **Submit um PR** com descrição detalhada

### Guidelines

- **SwiftUI Best Practices** - Siga as melhores práticas do SwiftUI
- **Accessibility** - Mantenha a acessibilidade
- **Performance** - Otimize para performance
- **Documentation** - Documente mudanças importantes

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- **Apple** - Pelo SwiftUI e macOS
- **Community** - Pela contribuição e feedback
- **Open Source** - Pelas bibliotecas e ferramentas utilizadas

---

**🎉 Desfrute da sua nova experiência de configuração HiDPI!**
