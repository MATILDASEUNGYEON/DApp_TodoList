const MyContract = artifacts.require("EditTodo");

module.exports = function (deployer) {
  deployer.deploy(MyContract);
};
