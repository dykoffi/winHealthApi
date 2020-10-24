const { Sequelize, DataTypes, Model } = require('sequelize')
const sequelize = new Sequelize('postgres://psante:7859@localhost:5432/seq') // Example for postgres

const Person = sequelize.define("person", {
    name: DataTypes.TEXT,
    favoriteColor: {
      type: DataTypes.TEXT,
      defaultValue: 'green'
    },
    age: DataTypes.INTEGER,
    cash: DataTypes.INTEGER
  });

(async () => {
    await sequelize.sync();
    const jane = await Person.create({
        username: 'dykoffi',
        name:"edy",
        age: 15,
        cash : 15000
    });
    jane.increment({age : 2})
    // jane.save()
    console.log(jane.toJSON());
})();