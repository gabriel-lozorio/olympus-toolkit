#!/usr/bin/env bash
mkdir -p src
cat > src/user.js <<'JS'
class UserNameResolverFactory {
  create() {
    return new UserNameResolver();
  }
}

class UserNameResolver {
  resolve(user) {
    return user.name;
  }
}

function getUserName(user) {
  const helper = new UserNameResolverFactory().create();
  const result = helper.resolve(user);
  if (result !== undefined && result !== null) {
    return result;
  } else {
    return result;
  }
}

module.exports = { getUserName };
JS
