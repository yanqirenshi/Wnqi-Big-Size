/* ******** */
/*  Request */
/* ******** */
var Uri = new Vanilla_URI();
var Request = new Vanilla_Ajax('http', 'localhost', '');
var API = new Vanilla_Ajax({
    scheme: _CONFIG.api.scheme,
    host: _CONFIG.api.host,
    port: _CONFIG.api.port,
    path: _CONFIG.api.path,
    credentials: 'include',
    callback: {
        401: function (r, api) {
            location.hash = '#sign-in';
        }
    }
});

/* ******* */
/*  Redux  */
/* ******* */
var ACTIONS = new Actions();
var REDUCER = new Reducer();
var STORE = new Store(REDUCER).init();

/* *********** */
/*  Metronome  */
/* *********** */
let Metronome = new Vanilla_metronome({
    interval: 1000 * 60,
    tick: function (count) {
        let pages = STORE.state().pages;
        let target = null;
        for(var k in pages)
            if(pages[k].display)
                target=pages[k];

        // if (target.code=='cockpit' && target.WBS.wbs_code)
        //     ACTIONS.loadPageWBS(target.WBS.wbs_code);

        // if (target.code=='wbs' && target.WBS.wbs_code)
        //     ACTIONS.loadPageWBS(target.WBS.wbs_code);
    }
});

/* ****** */
/*  main  */
/* ****** */
route.start(function () {
    let hash = location.hash;
    let len = hash.length;
    if (len==0)
        return '/';
    return hash.substring(1);
}());
riot.mount('*');
Metronome.start();
