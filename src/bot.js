import { Context, Telegraf } from "telegraf"

const bot = new Telegraf(process.env.BOT_TOKEN)
bot.command('start', (ctx) => ctx.reply('Welcome!'))
bot.command('deposit', (ctx) => ctx.reply())
console.log("Launching: ")
bot.launch()