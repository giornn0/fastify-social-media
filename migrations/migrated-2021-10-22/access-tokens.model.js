const mongod = require('mongoose')

const accessSchema = new mongod.Schema(
    {
        tokenable_id:{
            type:String,
            required:true
        },
        tokenA:{
            type:String,
            required:true
        },
        tokenR:{
            type:String,
            required:true
        },
        session_start:{
            type:Date,
            default: new Date
        }
    }
)
const access = mongod.model("PersonalAccessTokens",accessSchema)
async function runSchema(){
    const test = await new access({tokenable_id:'asd',tokenA:'asd',tokenR:'qwee'}).save()
    await access.findByIdAndDelete(test['_id'])
}
module.exports = runSchema()