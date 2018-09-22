tinymce.init({
  selector: 'textarea',
  height: 300,
  menubar: false,
  branding: false,
  plugins: [
    'advlist autolink lists link image'
  ],
  toolbar: 'bold italic backcolor | alignleft aligncenter alignright alignjustify | advlist autolink lists link image',
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css']
});
