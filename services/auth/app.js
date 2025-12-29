import express from "express";
import dotenv from "dotenv";
import cors from "cors"


// routes import
import superAdminAuthRoute from "./src/routes/superadminauth.routes.js";

const app = express()

dotenv.config()
app.use(express.json())
app.use(cors())

const PORT = process.env.PORT || 3000;

// routes
app.use('/api/super-admin-auth', superAdminAuthRoute);


app.get("/health", (req, res) => {
    console.log("server is now runing")
    return res.status(200).json({message: "all good"})
})

app.listen(PORT, ()=>{
    console.log(`app is listening on http://localhost:${PORT}`)
})



export default app;