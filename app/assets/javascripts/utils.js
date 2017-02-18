window.Utils = {
//   // Public: Converts the given string to CamelCase.
//   camelize: (s) => {
//     return typeof s === 'string' ?
//       s.replace(/(?:[-_])(\w)/g, function(_, c) { return c ? c.toUpperCase() : ''; }) : s;
//   };

//   // Public: Converts the given string to under_score_case.
//   underscore: (s) => {
//     return typeof s === 'string' ?
//       s.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase() : s;
//   };

//   // Public: Capitalizes the first letter of the given string.
//   capitalize: (s) => {
//     return typeof s === 'string' && s.length ? s[0].toUpperCase() + s.slice(1) : s;
//   };

// // ^^^ Taken from https://github.com/centro/transis/blob/master/src/util.js

//   const post = (path, params) => $.post(path, this.serializeParams(params));

//   const serializeParams = (params) => {
//     return $.param(underscoreParams(params));
//   };

//   const underscoreParams = (params) => {
//     return _.object(_.map(params, (value, key) => {
//       newVal = _.isEmpty(value) ? '' :
//         Array.isArray(value) ? value :
//         typeof value === 'object' ? underscoreParams(value) :
//         value;
//       return [underscoreString(key), newVal];
//     }));
//   };

//   // Taken from https://github.com/centro/transis/blob/master/src/util.js
//   const underscoreString = (s) => {
//     return typeof s === 'string' ?
//       s.replace(/([a-z\d])([A-Z]+)/g, '$1_$2').replace(/[-\s]+/g, '_').toLowerCase() : s;
//   };
}
