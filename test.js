const child = require('child_process');
const { stderr } = require('process');

child.exec('hostname -I', (error, stdout, stderr) => {
    console.log(stdout);
})