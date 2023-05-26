# 使用

替换或新增 /opt/homebrew/lib/node_modules 目录下的leetcodecli

## 登录异常

将 leetcodecli-config/leetcode-cli/lib/config.js 中的 leetcode.com 都改成 leetcode.cn

````js
'use strict';
var _ = require('underscore');
var nconf = require('nconf');

var file = require('./file');

const DEFAULT_CONFIG = {
  // usually you don't wanna change those
  sys: {
    categories: [
      'algorithms',
      'database',
      'shell'
    ],
    langs: [
      'bash',
      'c',
      'cpp',
      'csharp',
      'golang',
      'java',
      'javascript',
      'kotlin',
      'mysql',
      'php',
      'python',
      'python3',
      'ruby',
      'rust',
      'scala',
      'swift'
    ],
    urls: {
      base:            'https://leetcode.cn',
      graphql:         'https://leetcode.cn/graphql',
      login:           'https://leetcode.cn/accounts/login/',
      problems:        'https://leetcode.cn/api/problems/$category/',
      problem:         'https://leetcode.cn/problems/$slug/description/',
      test:            'https://leetcode.cn/problems/$slug/interpret_solution/',
      session:         'https://leetcode.cn/session/',
      submit:          'https://leetcode.cn/problems/$slug/submit/',
      submissions:     'https://leetcode.cn/api/submissions/$slug',
      submission:      'https://leetcode.cn/submissions/detail/$id/',
      verify:          'https://leetcode.cn/submissions/detail/$id/check/',
      favorites:       'https://leetcode.cn/list/api/questions',
      favorite_delete: 'https://leetcode.cn/list/api/questions/$hash/$id',
      plugin:          'https://github.com/skygragon/leetcode-cli-plugins/raw/master/plugins/$name.js'
    }
  },

  // but you will want change these
  autologin: {
    enable: false,
    retry:  2
  },
  code: {
    editor: 'vim',
    lang:   'cpp'
  },
  file: {
    show:       '${fid}.${slug}',
    submission: '${fid}.${slug}.${sid}.${ac}'
  },
  color: {
    enable: true,
    theme:  'default'
  },
  icon: {
    theme: ''
  },
  network: {
    concurrency: 10,
    delay:       1
  },
  plugins: {}
};

function Config() {}

Config.prototype.init = function() {
  nconf.file('local', file.configFile())
    .add('global', {type: 'literal', store: DEFAULT_CONFIG})
    .defaults({});

  const cfg = nconf.get();
  nconf.remove('local');
  nconf.remove('global');

  // HACK: remove old style configs
  for (let x in cfg) {
    if (x === x.toUpperCase()) delete cfg[x];
  }
  delete DEFAULT_CONFIG.type;
  delete cfg.type;

  _.extendOwn(this, cfg);
};

Config.prototype.getAll = function(useronly) {
  const cfg = _.extendOwn({}, this);
  if (useronly) delete cfg.sys;
  return cfg;
};

module.exports = new Config();

````

