const mongod = require('mongoose')

const userSchema = new mongod.Schema({
    name:{
        type:String,
        required:true,
        maxlength:50
    },
    last_name:{
        type:String,
        required:true,
        maxlength:50
    },
    username:{
        type:String,
        required:true,
        unique:true,
        maxlength:50
    },
    email:{
        type:String,
        required:true,
        unique:true,
        maxlength:50
    },
    password:{
        type:String,
        required:true,
        maxlength:50,
        minlength:6
    },
    password:{
        type:String,
        required:true,
        maxlength:50,
        minlength:6
    },
    profile_picture:{
        type:String,
        default:''
    },
    cover_picture:{
        type:String,
        default:''
    },
    followers:{
        type:Array,
        default:[]
    },
    following:{
        type:Array,
        default:[]
    },
    relation_status:{
        type: Number,
        enum:[1,2,3]
    },
    isAdmin:{
        type: Boolean,
        default: false
    },
    description:{
        type:String,
        maximum:50
    },
    city:{
        type:String,
        max:50
    },
    from:{
        type:String,
        max:50
    },
},
{
    timestamps:true
}
)
const user = mongod.model("User",userSchema)
async function runSchema(){
    const test = await new user({name:'asd',last_name:'asd',username:'qwee',email:'qwee',password:'qweeasd'}).save()
    await user.findByIdAndDelete(test['_id'])
}

module.exports =runSchema()