<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
.normal-mode .edit-mode-item {
  display:none;
}

.edit-mode .normal-mode-item {
  display:none;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 라이브러리명 : 폰트어썸 -->
<!-- 아이콘 라이브러리 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.6.3/css/font-awesome.min.css">

<!-- 라이브러리명 : 노말라이즈 -->
<!-- 다양한 웹 브라우저 간 레이아웃, 디자인 평준화  -->

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/4.2.0/normalize.min.css">

<!-- 라이브러리명 : jQuery -->
<!-- 필수라이브러리 -->
<!-- 브라우저 마다 다른 자바스크립트 API 문제를 해결 -->
<!-- 브라우저가 기본적으로 제공하는 라이브러리 보다 훨씬 직관적인 API 제공 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<!-- 라이브러리명 : 부트스트랩  -->
<!-- UI 프레임워크 -->
<!-- 멋진 디자인을 쉽게 만들 수 있도록 도와준다. -->
<!-- 반응형 디자인 웹을 만들어 준다. -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/css/bootstrap.css">

<!-- 부트스트랩 -->
<!-- 부트스트랩은 js 와 css 파일이 한쌍이다. -->
<!-- 부트스트랩 js는 jQuery를 사용한다. 즉 jQuery 보다 밑에서 로드되어야 한다. -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/store.js/1.3.20/store+json2.min.js"></script>

<h1>할일 리스트</h1>

<input type="text" name="todo">
<button class="btn btn-primary" name="add-btn">할일 추가</button>

<ul class="main-list">
</ul>
<script type="text/javascript">
//기존 저장소에서 할일리스트를 가져온다.
var todoList = store.get('todoList');

// 저장소에 할일리스트 데이터가 없는 경우
if ( !todoList ) {
  // 할일 리스트 초기화
  todoList = [];
}

// 할일리스트 초기화
function init() {
  for ( var i = todoList.length - 1; i >= 0; i-- ) {
    addLi(todoList[i]);
  }
}

// 할일리스트 추가 버튼 jQuery 엘리먼트 구하기
var $addBtn = $('button[name=add-btn]');

// 추가 버튼에 이벤트 걸기
$addBtn.on('click', function() {
  addLiByInput();
});

// 리스트아이템 추가 by INPUT
function addLiByInput() {
  // INPUT jQuery 엘리먼트를 구한다.
  var $todoInput = $('input[name=todo]');
  
  // 공백을 없앤다.
  $todoInput.val($.trim($todoInput.val()));
  
  // 입력값 체크
  if ( $todoInput.val() == '' ) {
    alert('할일을 입력해주세요.');
    $todoInput.focus();
    return false;
  }
  
  // 입력상자의 값 가져오기
  var todo = $todoInput.val();
  
  // addLi 함수 호출
  addLi(todo);
  
  // 입력상자 비우기
  $todoInput.val('');
  updateTodoListOnStorage();
}

function addLi(todo) {
   var liHtml = '';
  
  liHtml += '<span class="normal-mode-item text">' + todo + '</span>';
  
  liHtml += '<input class="edit-mode-item edit-text-input" type="text">';
  
  liHtml += ' <button class="edit-mode-item btn btn-success" onclick="saveBtnClicked(this);">저장</button>';
  
  liHtml += ' <button class="edit-mode-item btn btn-warning" onclick="cancelBtnClicked(this);">취소</button>';
  
  liHtml += ' <button class="normal-mode-item btn btn-info" onclick="editBtnClicked(this);">수정</button>';
  
  liHtml += ' <button class="normal-mode-item btn btn-danger" onclick="deleteBtnClicked(this);">삭제</button>';
  
  liHtml = '<li class="normal-mode">' + liHtml + '</li>';
  
  $('.main-list').prepend(liHtml);
}

function deleteBtnClicked(btn) {
  var $btn = $(btn);
  $btn.parent().remove();
  updateTodoListOnStorage();
}

function editBtnClicked(btn) {
  var $btn = $(btn);
  
  var $li = $btn.parent();
  
  $text = $li.find('.text');
  $editTextIntput = $li.find('.edit-text-input');
  
  $editTextIntput.val($text.text().trim());
  
  changeLiMode($li, 'edit');
}

function saveBtnClicked(btn) {
  var $btn = $(btn);
  
  var $li = $btn.parent();
  
  $text = $li.find('.text');
  $editTextIntput = $li.find('.edit-text-input');
  
  $editTextIntput.val($editTextIntput.val().trim());
  
  if ( $editTextIntput.val() == "" ) {
    alert('내용을 입력해주세요.');
    $editTextIntput.focus();
    
    return false;
  }
  
  $text.text($editTextIntput.val());
  
  changeLiMode($li, 'normal');
  updateTodoListOnStorage();
}

function cancelBtnClicked(btn) {
  var $btn = $(btn);
  
  var $li = $btn.parent();
  
  changeLiMode($li, 'normal');
}

function changeLiMode($li, mode) {
  if ( mode == 'normal' ) {
    $li.removeClass('edit-mode');
  }
  else if ( mode == 'edit' ) {
    $li.removeClass('normal-mode');
  }
  
  $li.addClass(mode + '-mode');
}

init();

function updateTodoListOnStorage() {
  todoList = [];
  
  $('.main-list li .text').each(function(index, node) {
    var $li = $(node);
    
    var todo = $li.text();
    
    todoList.push(todo);
  });
  
  store.set('todoList', todoList);
}
</script>
</body>
</html>