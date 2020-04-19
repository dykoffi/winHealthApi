exports.BEGIN = (client)=>{
    client.query("BEGIN")
}
exports.COMMIT = (client)=>{
    client.query("COMMIT")
}
exports.ROLLBACK = (client)=>{
    client.query("ROLLBACK")
}