//= require project/app/config
//= require project/app/init

// --------------------------------------------------------------
// NOTE: Dependencies must be declared before 'require_tree'
// --------------------------------------------------------------
//= require_tree ./project/models
//= require_tree ./project/modules

// --------------------------------------------------------------
// NOTE: Order is significant
// --------------------------------------------------------------
//= require project/routers/notfound
//= require project/routers/video

//= require project/app/start