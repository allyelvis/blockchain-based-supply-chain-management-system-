const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();
const app = express();

app.use(express.json());
app.use(require('cors')());

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/supply-chain', {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => console.log("MongoDB Connected"));

app.get('/', (req, res) => res.send('API is running'));

app.listen(5000, () => console.log('Backend listening on http://localhost:5000'));
