# RC Admin App 📱

O **RC Admin App** é uma aplicação móvel desenvolvida em **Flutter** para gerenciamento de perfil de usuários, controle de frequências e administração institucional. O projeto utiliza uma arquitetura baseada em serviços, gerenciamento de estado com `Provider` e autenticação via JWT.

---

## 🚀 Funcionalidades Principais

- **Autenticação Segura:** Login com JWT (Access Token + Refresh Token).
- **Gestão de Perfil:** Visualização e edição de dados cadastrais.
- **Segurança:**
  - Troca de senha (usuário logado).
  - Recuperação de senha ("Esqueci minha senha") via OTP (e-mail).
  - Troca de e-mail com fluxo de verificação.
- **Mídia:** Upload, visualização e remoção de foto de perfil (Câmera e Galeria).
- **Navegação:** Menu lateral (Drawer) e rotas nomeadas.

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter (SDK ^3.10.4)
- **Gerenciamento de Estado:** `provider`
- **Comunicação HTTP:** `http`
- **Mídia:** `image_picker`
- **UI:** Material Design

---

## 📂 Estrutura do Projeto

O código está organizado para separar a lógica de negócio da interface do usuário:

```
lib/
├── config/         # Configurações globais (URLs da API, constantes)
├── models/         # Modelos de dados e Gerenciamento de Estado (Auth, UserProfile)
├── screens/        # Telas completas (Login, Profile, EditProfile)
├── service/        # Camada de comunicação com a API (GET, POST, PATCH, Multipart)
├── utils/          # Lógica auxiliar e Modais (Validadores, OTP, Upload de Imagem)
├── widgets/        # Componentes visuais reutilizáveis (Cards, Inputs, Drawer)
└── main.dart       # Ponto de entrada, rotas e injeção de dependências
```

---

## ⚙️ Configuração e Instalação

### Pré-requisitos
- Flutter SDK instalado.
- Emulador Android/iOS ou dispositivo físico.

### Passos
1. **Clone o repositório:**
   ```bash
   git clone <url-do-repositorio>
   cd rcadminapp
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto:**
   ```bash
   flutter run
   ```

### ⚠️ Nota sobre Certificados SSL
Atualmente, o arquivo `main.dart` possui uma classe `MyHttpOverrides` que ignora erros de certificado SSL para facilitar o desenvolvimento local. **Isso deve ser removido antes de gerar a versão de produção.**

---

## 📱 Permissões do Dispositivo

Para que o upload de fotos funcione, as seguintes permissões foram configuradas:

### Android (`AndroidManifest.xml`)
- `CAMERA`: Para tirar fotos.
- `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES`: Para acessar a galeria.
- `INTERNET`: Para comunicação com a API.

### iOS (`Info.plist`)
- `NSPhotoLibraryUsageDescription`: Acesso à galeria.
- `NSCameraUsageDescription`: Acesso à câmera.

---

## 📖 Documentação dos Fluxos Principais

### 1. Autenticação (Login & Refresh Token)
- **Login:** O usuário envia credenciais e recebe um `access_token` e um `refresh_token`.
- **Persistência:** Os tokens são mantidos na memória via `Auth Provider`.
- **Renovação Automática:** Se uma requisição retornar `401 Unauthorized`, o `ProfileService` intercepta o erro, usa o `refresh_token` para obter um novo acesso e refaz a requisição original transparentemente.
- **Logout:** Limpa os tokens da memória e remove o histórico de navegação, redirecionando para o Login.

### 2. Gestão de Perfil (CRUD)
- **Leitura:** Ao abrir o perfil, o app busca os dados (`fetchProfile`).
- **Edição:** O usuário altera dados textuais. Ao salvar, um `PATCH` é enviado. A tela anterior é atualizada via callback `onReturn`.
- **Troca de E-mail:** Requer validação. O usuário insere o novo e-mail, o sistema envia confirmação e desloga o usuário para forçar novo login.

### 3. Troca de Senha
- **Logado:** O usuário deve informar a senha antiga e a nova.
- **Esqueci a Senha:**
  1. Usuário informa e-mail.
  2. Recebe código OTP.
  3. Insere OTP no App.
  4. App valida OTP e recebe um `reset_token`.
  5. App envia `reset_token` + `nova_senha`.

### 4. Upload de Imagem
- Utiliza `MultipartRequest` para envio de arquivos.
- **Cache Busting:** Para garantir que a nova foto apareça imediatamente, o app:
  1. Exibe a imagem local (arquivo) temporariamente.
  2. Adiciona um timestamp na URL da imagem (`image.jpg?v=12345`) para enganar o cache do dispositivo.
  3. Limpa o cache de memória (`evict`) da imagem antiga.

---

## 🧩 Componentes Chave

| Componente | Função |
|Data | Descrição |
|---|---|
| `Auth (ChangeNotifier)` | Gerencia o estado global de autenticação (tokens). |
| `ProfileService` | Centraliza todas as chamadas HTTP e tratamento de erros (401, 400, 500). |
| `RcaDrawer` | Menu lateral com navegação e exibição resumida do usuário. |
| `UserProfileCard` | Card principal de exibição de dados e ponto de entrada para edições. |
| `OtpForm` | Modal reutilizável para validação de códigos de segurança. |

---

## 🤝 Como Contribuir

1. Faça um Fork do projeto.
2. Crie uma Branch para sua Feature (`git checkout -b feature/NovaFeature`).
3. Faça o Commit (`git commit -m 'Adicionando NovaFeature'`).
4. Faça o Push (`git push origin feature/NovaFeature`).
5. Abra um Pull Request.

---

**Desenvolvido para RC Admin.**
