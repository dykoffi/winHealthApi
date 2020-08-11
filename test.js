const child = require('child_process');
const { stderr } = require('process');
const forward =  require('http-port-forward')
forward(8001,8002)
child.exec('hostname -I', (error, stdout, stderr) => {
    console.log(stdout);
})