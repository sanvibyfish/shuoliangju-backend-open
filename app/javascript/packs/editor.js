import "quill"
import "../styles/editor";
import imageUpload from 'quill-plugin-image-upload';
Quill.register('modules/imageUpload', imageUpload);
Quill.prototype.getHtml = function() {
  return this.container.firstChild.innerHTML;
};
Quill.prototype.setHtml = function(value) {
  this.container.firstChild.innerHTML = value;
};
document.addEventListener('turbolinks:load', () => {

  const toolbarOptions = [
    ["bold", "italic", "underline", "strike"], // 加粗 斜体 下划线 删除线
    ["blockquote", "code-block"], // 引用  代码块
    [{ header: 1 }, { header: 2 }], // 1、2 级标题
    [{ list: "ordered" }, { list: "bullet" }], // 有序、无序列表
    [{'direction': 'rtl'}],                         // 文本方向
    [{ size: ["small", false, "large", "huge"] }], // 字体大小
    [{ header: [1, 2, 3, 4, 5, 6, false] }], // 标题
    [{ color: [] }, { background: [] }], // 字体颜色、字体背景颜色
    [{ font: [] }], // 字体种类
    [{ align: [] }], // 对齐方式
    ["clean"], // 清除文本格式
    ["image"] // 链接、图片、视频
  ];
  var quill = new Quill(document.querySelector('#article_content'), {
    modules: {
      toolbar: toolbarOptions,
      imageUpload: {
        upload: file => {
          // return a Promise that resolves in a link to the uploaded image
          return new Promise((resolve, reject) => {
            const formData = new FormData()
            formData.append('upload', file)
            var token = $('meta[name="csrf-token"]').attr('content');

            let url = '/attachments';
            fetch(url, { // Your POST endpoint
              method: 'POST',
              headers: {
                // Content-Type may need to be completely **omitted**
                // or you may need something
                // "Content-Type": "multipart/form-data"
                'X-CSRF-Token': token
              },
              body: formData // This is your file object
            }).then(
              response => response.json() // if the response is a JSON object
            ).then(
              success => {
                console.log(success.url)
                resolve(success.url)
              }
            ).catch(
              error => reject(error)
            );

            // $.ajax(
            //   {
            //     method: "POST",
            //     url: "/attachments",
            //     data: file
            //   }
            // ).done(data => );
          });
        }
      },
    },
    theme: 'snow'
  })

  var form = document.querySelector('form');
  form.onsubmit = function () {
    // Populate hidden form on submit
    var content = document.querySelector('input[id=hidden_content]')
    content.value = quill.getHtml()
    return true;
  };
  var hiddenContent = document.querySelector('input[id=hidden_content]');
  if(hiddenContent.value) {
    quill.setHtml(hiddenContent.value)
  }
})