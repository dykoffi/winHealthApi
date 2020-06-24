const router = require('express').Router()
const moment = require('moment')

moment.locale('fr')

router
.get('/index',(req,res)=>{
    res.render("index")
})

module.exports = router
