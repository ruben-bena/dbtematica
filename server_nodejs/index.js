const express = require('express');
const fs = require('fs/promises');
const path = require('path');

const app = express();
const PORT = 3000;

const categoryFiles = {
  characters: 'characters.json',
  consoles: 'consoles.json',
  games: 'games.json',
};

app.use(express.json());

app.post('/categorias', async (req, res) => {
  try {
    const categoria = req.body?.categoria;
    const fileName = categoryFiles[categoria];

    if (!fileName) {
      return res.status(400).json({
        error: 'Categoría inválida. Usa: characters, consoles o games.',
      });
    }

    const filePath = path.join(__dirname, 'assets', fileName);
    const jsonContent = await fs.readFile(filePath, 'utf8');
    const items = JSON.parse(jsonContent);

    return res.json(items);
  } catch (error) {
    return res.status(500).json({ error: 'No se pudo leer la categoría solicitada.' });
  }
});

app.get('/imagen', async (req, res) => {
  try {
    const nombre = req.query.nombre;
    if (typeof nombre !== 'string' || nombre.trim().length === 0) {
      return res.status(400).json({ error: 'Debes indicar el parámetro ?nombre=' });
    }

    const safeName = path.basename(nombre);
    const imagePath = path.join(__dirname, 'assets', 'images', safeName);
    const imageBuffer = await fs.readFile(imagePath);

    return res.json({
      nombre: safeName,
      base64: imageBuffer.toString('base64'),
    });
  } catch (error) {
    if (error && error.code === 'ENOENT') {
      return res.status(404).json({ error: 'Imagen no encontrada.' });
    }
    return res.status(500).json({ error: 'No se pudo cargar la imagen solicitada.' });
  }
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
