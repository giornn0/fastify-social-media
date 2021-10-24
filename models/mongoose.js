const mongod = require('mongoose')

if(!process.env.PRODUCTION){
    dotenv = require('dotenv');
    dotenv.config()
}
console.log('Starting mongoDB connection!')
async function startMigration (){
    return mongod.connect( process.env.MONGO_URL)
        .then(()=>{
            console.log('Connection established!')
        })
        .catch(err=>console.log(err))
}


async function start(){
await startMigration()

console.log('Migrations done')
process.exit()
}

start()



// const d = require('domain').create();

// d.on('error', function(er) {
//     console.log(er);
// });

// d.start(function() {
//     mongoose.connect(config.db, options);
// });