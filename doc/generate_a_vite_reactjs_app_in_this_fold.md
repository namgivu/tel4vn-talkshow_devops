### What you want
Generate a new Vite + React app in the existing folder:
`...talkshow_devops/vitereactjs_webapp`

Vite’s scaffolder expects an empty directory. 


### Prerequisites
- Node.js 18 or newer (Vite 5 requires this). Check with `node -v`.
- A package manager: `npm` (default), or `pnpm`, or `yarn`.


### Scaffold directly in the folder (recommended if you don’t need to keep current files)
1) Open Terminal and run:
3) Create a React app with Vite in the current directory (JavaScript + SWC for speed):
```
cd vitereactjs_webapp
npm create vite@latest . -- --template react-swc

# for typescript
npm create vite@latest . -- --template react-swc-ts  
```

5) Install dependencies and start the dev server:
```
npm install
npm run dev

# start on a custom port
npm run dev -- --port 5174  
```
5) Visit the printed URL eg http://localhost:5173


### Common tweaks after scaffolding
- Update project name in `package.json` (`name` field).
- Initialize git if needed 

- Build and preview to verify production build:
```
npm run build
npm run preview
```
