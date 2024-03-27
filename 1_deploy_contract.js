const MyContract = artifacts.require("TodoList");

module.exports = function (deployer) {
  deployer.deploy(MyContract);
};
