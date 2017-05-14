// Load the plugins
var gulp = require('gulp');
var concat = require('gulp-concat');
var compass = require('gulp-compass');
var browserSync = require('browser-sync');
var minifyCss = require('gulp-clean-css');
var cp = require('child_process');
var pump = require('pump');
var sourcemaps = require('gulp-sourcemaps');
var babel = require('gulp-babel');
var uglify = require('gulp-uglify');
var nightmare = require('nightmare');
var imagemin = require('gulp-imagemin');


gulp.task('optimize-images', function () {
  gulp.src(['images/**/*', 'uploads/**/*'])
    .pipe(imagemin())
    .pipe(gulp.dest('images'));
});


// Shortcut for purging cloudflare
// gulp.task('cf-purge', function(done) {
//   return cp.spawn('cfcli', ['purge', '-d', 'dcfacades.com'], {stdio: 'inherit'})
//     .on('close', done);
// });

// Shortcut for pushing algolia search index
// gulp.task('algolia-push', ['build-all'], function (done) {
//   cp.spawn('bundle', ['exec', 'jekyll', 'algolia', 'push'], {stdio: 'inherit'})
//     .on('close', done);
// });


// Starts a webserver, takes a snapshot, closes webserver, optimizes snapshot
// Requires http-server to be installed globally using `npm install -g http-server`
// Requires imagemagick to be installed globally using `brew install imagemagick`
// Requires jpegtran to be installed globally using `brew install jpegtran`
gulp.task('screenshot', function (done) {

  var child = cp.spawn('http-server', ['-p', '9000', '_site'], {stdio: 'inherit'});

  return nightmare()
    .goto('http://localhost:9000')
    .viewport(1200, 1200)
    .screenshot('tmp/screenshot.png')
    .end()
    .then(function (result) { return child.kill(); })
    .then(function (result) {
      return cp.spawn('convert', ['-resize', '1200', 'tmp/screenshot.png', 'tmp/screenshot.jpg'], {stdio: 'inherit'})
        .on('close', function() {
          return cp.spawn('jpegtran', ['-optimize', '-progressive', '-outfile', 'images/screenshot.square.jpg', 'tmp/screenshot.jpg'], {stdio: 'inherit'})
            .on('close', function () {
              return cp.spawn('jpegtran', ['-optimize', '-progressive', '-crop', '1200x500', '-outfile', 'images/screenshot.fold.jpg', 'tmp/screenshot.jpg'], {stdio: 'inherit'});
            });
        });
    })
    .catch(function (error) {
      child.kill();
      console.error('Screenshot failed:', error);
      return done(error);
    })
    ;
});


gulp.task('css', function (cb) {
  pump([
      gulp.src('css/_src/screen.scss'),
      compass({
        css: 'css',
        sass: 'css/_src',
        image: 'images',
        sourcemap: 'css',
        style: 'compressed'
      })
      // browserSync.reload({stream: true}),
    ],
    cb
  );
});


gulp.task('js-libs', function (cb) {
  pump([
      gulp.src([
        'js/_src/libs/jquery.js',
        'js/_src/libs/jquery.dropotron.js',
        'js/_src/libs/skel.js',
        'js/_src/libs/skel-viewport.js',
        'js/_src/libs/smooth-scroll.js'
      ]),
      sourcemaps.init(),
      concat('libs.min.js'),
      uglify({preserveComments: 'license'}),
      sourcemaps.write('.'),
      gulp.dest('js')
    ],
    cb
  );
});


gulp.task('js-custom', function (cb) {

  pump([
      gulp.src([
        'js/_src/smooth-scroll-init.js',
        'js/_src/load-deferred-images.js',
        'js/_src/util.js',
        'js/_src/main.js'
      ]),
      sourcemaps.init(),
      babel({
        presets: ['es2015'],
        compact: true
      }),
      concat('custom.min.js'),
      uglify(),
      sourcemaps.write('.'),
      gulp.dest('js')
    ],
    cb
  );
});


gulp.task('js-production', ['js-libs', 'js-custom'], function (cb) {
  pump([
      gulp.src([
        'js/libs.min.js',
        'js/custom.min.js'
      ]),
      concat('bundle.min.js'),
      uglify({preserveComments: 'license'}),
      gulp.dest('js')
    ],
    cb
  );
});


gulp.task('jekyll-build', function (done) {
  browserSync.notify('<span style="color: grey">Running:</span> $ bundle exec jekyll build');
  return cp.spawn('bundle', ['exec', 'jekyll', 'build', '--incremental'], {stdio: 'inherit'})
    .on('close', done);
});


gulp.task('jekyll-rebuild', ['jekyll-build'], function () {
  browserSync.reload();
});


gulp.task('browser-sync', ['build-all'], function () {
  browserSync({
    server: {
      baseDir: '_site',
      serveStaticOptions: {
        extensions: ["html"]
      }
    }
  });
});


gulp.task('watch', function () {
  gulp.watch('css/_src/*', ['css']);
  gulp.watch('js/_src/*', ['js-production']);
  gulp.watch(['_config.yml', '*.html', '_layouts/*.html', '_includes/*.html', '_posts/*.md', 'css/*.css', 'js/*.js'], ['jekyll-rebuild']);
});

gulp.task('build-all', ['css', 'js-production', 'jekyll-build']);
gulp.task('serve', ['browser-sync', 'watch']);


// gulp.task('deploy', ['algolia-push'], function (done) {
gulp.task('deploy', ['build-all'], function (done) {
  cp.spawn('git', ['push'], {stdio: 'inherit'})
    .on('close', done)
});

gulp.task('default', ['build-all']);