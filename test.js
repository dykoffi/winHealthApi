const axios = require("axios");

const TWILIO_PHONE_NUMBER = "51886478"
const UNITED_STATES_COUNTRY_CODE = "+225"

const sendSMS = (body, to) => axios({
    method: "POST",
    url: `https://twilio-sms.p.rapidapi.com/2010-04-01/Accounts/ALTEA/Messages.json`,
    headers: {
        "content-type": "application/x-www-form-urlencoded",
        "x-rapidapi-host": "twilio-sms.p.rapidapi.com",
        "x-rapidapi-key": '066af57313msh22b8cb405e9af41p14c1bdjsnd5f6d005a444'
    },
    params: {
        from: TWILIO_PHONE_NUMBER,
        body,
        to: UNITED_STATES_COUNTRY_CODE + to
    }
})

sendSMS("bonjour",'55854685')

