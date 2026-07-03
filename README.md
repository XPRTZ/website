# 🚀 Getting started

## Prerequisites
- WSL
- Git
- Node 20+ (see `.nvmrc`)
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install -y nodejs
```

## Getting started
1. Clone the repository in WSL
   ```bash
   git clone https://github.com/xprtz/website.git
   ```
2. Install dependencies
   ```bash
   npm install
   ```
3. Create the `.env` file for the app(s) you want to run from the sample file
   ```bash
   cp apps/dotnet/.env.example apps/dotnet/.env
   ```
   - `PUBLIC_STRAPI_URL`: The URL of the Strapi CMS (run the [cms](https://github.com/xprtz/cms) project locally, or point to a hosted instance).
   - `PUBLIC_IMAGES_URL`: The URL used to resolve media served by Strapi, usually the same as `PUBLIC_STRAPI_URL`.
4. Start the app you want to work on
   ```bash
   npm run develop:dotnet
   ```
   or
   ```bash
   npm run develop:learning
   ```
5. Open the app in your browser
   ```bash
   http://localhost:3001 # dotnet
   http://localhost:3004 # learning
   ```
