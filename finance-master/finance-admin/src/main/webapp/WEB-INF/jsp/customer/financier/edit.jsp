<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<jsp:include page="${pageContext.request.contextPath}/header" flush="true" />
	<link href="${pageContext.request.contextPath}/res/plugin/select/select2.css" rel="stylesheet" />
	<body>
		<jsp:include page="${pageContext.request.contextPath}/menu" flush="true" />
        <div class="container-fluid">
            <div class="row-fluid">
                <jsp:include page="${pageContext.request.contextPath}/sidebar" flush="true" />
                <div class="span10" id="content">
                    <div class="row-fluid">
                        <!-- block -->
                        <div class="block">
                            <jsp:include page="${pageContext.request.contextPath}/breadcrumb" flush="true" />
                            <div class="block-content collapse in">
			                    <form class="form-horizontal" enctype="multipart/form-data" id="fm" method="post" >
									<div class="well">
										<input id="id" name="id" value="${financier.id}" type="hidden">
										<input name="status" value="${financier.status}" type="hidden">
										<input id ="licenseImage" name="licenseImage" value="${financier.licenseImage}" type="hidden">
				                    	<input name="base64" value="${base64}" type="hidden">
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>商户名称</label>
											<div class="controls"><input name="name" type="text" value="${financier.name}" onkeyup="this.value=this.value.replace(/(^\s*)/g,'')" onblur="this.value=this.value.replace(/(\s*$)/g,'')" placeholder="4~40个字符" class="validate[required, minSize[4], maxSize[40]] text-input span8" /></div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>证件号码</label>
											<div class="controls"><input name="license" type="text" value="${financier.license}" class="text-input span8" readonly="readonly" /></div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>证件图片</label>
											<div class="controls">
												<a id="previewImage" class="thumbnail" style="float:left;height:297px; width:210px;">
													<img class="previewImage" style="float:left;height:297px; width:210px;" src="${financier.licenseImage}" />
												</a>
											</div>
										</div>
										<div class="control-group">
											<label class="control-label">&nbsp;</label>
											<div class="controls" id="licenseContainer">
												<a href="javascript:reUpload('${financier.licenseImage}');"><button type="button" id="reUploadButton" class="btn btn-primary">重新上传 </button></a>
											</div>
										</div>
										<div class="control-group" id="progress">
											<div class="controls" id="fileName"></div>
										    <div class="controls" id="fileSize"></div>
										    <div class="controls">
										    	<div class="progress">
											    	<div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width:0%;background-color:red;">
											      		<span class="sr-only">0% 完成</span>
											   		</div>
											   </div>
										    </div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>手机号码</label>
											<div class="controls"><input name="cellphone" type="text" value="${financier.cellphone}" class="validate[required, custom[cellphone]] text-input span8" /></div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>联系地址</label>
											<div class="controls"><input name="address" type="text" value="${financier.address}" placeholder="10~100个字符" onkeyup="this.value=this.value.replace(/(^\s*)/g,'')" onblur="this.value=this.value.replace(/(\s*$)/g,'')" class="validate[required, minSize[10], maxSize[100]] text-input span8" /></div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>银行账户</label>
											<div class="controls"><input type="text" name="cardNO" value="${financier.cardNO}" class="validate[required, custom[bankCode]] text-input span8" /></div>
										</div>
										<div class="control-group">
											<label class="control-label"><span class="required">*</span>所属银行</label>
											<div class="controls">
												<select id="bankName" name="bankName" class="validate[required] span8">
													<option value=""></option>
		                                            <c:forEach items="${banks}" var="bank">
		                                            	<c:choose>
		                                            		<c:when test="${bank.bankName eq financier.bankName}">
		                                            		<option value="${bank.bankName}" selected="selected">${bank.bankName}</option>
		                                            		</c:when>
		                                            		<c:otherwise>
		                                            		<option value="${bank.bankName}">${bank.bankName}</option>
		                                            		</c:otherwise>
		                                            	</c:choose>
		                                            </c:forEach>
												</select>
											</div>
										</div> 
										<div class="form-actions">
											<button type="button" id="save" onclick="uploadFile();" class="btn btn-icon btn-primary glyphicons circle_ok">保存</button>
											<a href="javascript:quit();"><button type="button" class="btn">返回</button></a>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
                </div>
            </div>
        </div>
		<jsp:include page="${pageContext.request.contextPath}/footer" flush="true" />
	</body>
	<script src="${pageContext.request.contextPath}/js/show.original.image.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			var category = '${category}';
			if (category && category == 'detail') {
				$('#save').hide();
				$('.breadcrumb').html('<li class="active">客户管理&nbsp;/&nbsp;<a href="javascript:quit();">商户管理</a>&nbsp;/&nbsp;查看</li>');
				readOnly();
			} else {
				$('#save').show();
				$('.breadcrumb').html('<li class="active">客户管理&nbsp;/&nbsp;<a href="javascript:quit();">商户管理</a>&nbsp;/&nbsp;编辑</li>');
			}
			$('.marginTop').css('margin', '2px auto auto auto');
			$('.msg').css('color', 'red');
			$('#progress').hide();
			$('.previewImage').click(ImgShow);
			$('#fm').validationEngine('attach', {
		        promptPosition:'bottomLeft',
		        inlineValidation: true, 
		        validationEventTriggers:'click blur', 
		        showOneMessage: true,
		        focusFirstField:true,
		        scroll: true
		    });
		});
		
		function readOnly() {   
	        var a = document.getElementsByTagName("input");   
	        for(var i=0; i<a.length; i++)   {   
	           if(a[i].type=="checkbox" || a[i].type=="text" || a[i].type=="radio"){
	        	   a[i].readOnly = true;
	        	   a[i].disabled = "disbaled";
	           }     
	        }
	        
	        var  b  =  document.getElementsByTagName("select");   
	        for(var i=0; i<b.length; i++)   {   
	              b[i].disabled="disabled";   
	        }
	        
	        var c = document.getElementsByTagName("textarea");
	        for (var i=0;   i<c.length; i++) {   
	              c[i].disabled="disabled";   
	        }
        	$('#reUploadButton').disabled="disabled"; 
		}
		
		var index = 0;
	    function startValidate() {
	    	if(index > 0) {
	    		if (!$('#files').val()) {
				    alert('请选择要上传的证件图片');
				    return false; 
			    }
	    	}
		   	return true;
		}
		
		function reUpload(name) {
			if(confirm("您确认要重新上传证件图片吗?")) {
				index++;
				$('#licenseContainer').html('<span><font style="color:red;">（建议：A4扫描件）</font></span><input id="files" type="file" name="files" accept="image/jpeg,image/png" onchange="selectFile();" />');
			}
	    }
		
		function selectFile() {
			var file = document.getElementById('files').files[0];
			$('#progress').hide();
           	if(file) {
           		if(/.*[\u4e00-\u9fa5]+.*$/.test(file.name)) {  
	                alert('文件名中不能含有中文！'); 
	                $('#files').val('');
	                return false;  
                }  
				
				var suffix = file.name.split('.').pop().toLowerCase();
	       	   	if(suffix == 'png' || suffix == 'jpg') {
	            	if (Math.round(file.size/1024) > 2048) {
	            	  	alert('亲，图片不能超过2M');
	        		  	$('#files').val('');
		              	return false;
					}
	              	
	              	var img = $('<img style="float:left;height:297px; width:210px;" src="'+window.URL.createObjectURL(file)+'" />');
	              	$('#previewImage').empty().append(img);
	              	
	              	$('#progress').show();
	                var fileSize = 0;
	                if(file.size > 1024 * 1024) {
	                    fileSize = Math.round(file.size/(1024 * 1024)).toString()+'MB';
	                } else {
	                    fileSize = Math.round(file.size/1024).toString()+'KB';
	                }
	                $('#fileName').html('文件名称:'+file.name);
	              	$('#fileSize').html('文件大小:'+fileSize);
	       		  	return true; 
				} else {
	       		   	alert('请选择png、jpg的图片！');
	       		   	$('#files').val('');
	               	return false;
				}
        	}
		}
	   	
	   	function uploadFile() {
	   		if(startValidate()) {
		   		var file = document.getElementById('files');
		        if(file) {
		        	$('#save').attr('disabled','disabled');
			        var fd = new FormData();
			        fd.append('url', document.getElementById('files').files[0]);
			        var xhr = new XMLHttpRequest();
			        xhr.upload.addEventListener('progress', uploadProgress, false);
			        xhr.addEventListener('load', uploadComplete, false);
			        xhr.open('POST', '${pageContext.request.contextPath}/web/upload');
			        xhr.send(fd); 
		        } else {
		        	$('#fm').attr('action', '${pageContext.request.contextPath}/customer/financier/save');
		            $('#fm').submit();
		        } 
	   		}
		}
	   
	    function uploadProgress(evt) {
	    	if(evt.lengthComputable) {
	        	var percentComplete = Math.round(evt.loaded*100/evt.total);
	            $('.progress-bar').css('width', percentComplete.toString()+'%');
	            $('.sr-only').html(percentComplete.toString()+'% 完成');
	        }
	    }
	      
	    function uploadComplete(evt) {
			$('#licenseImage').val(evt.target.responseText);
	   	   	$('#fm').attr('action', '${pageContext.request.contextPath}/customer/financier/save');
            $('#fm').submit();
	   	}
		
		function quit() {
			window.location.href='${pageContext.request.contextPath}/customer/financier/${base64}';
		}
	</script>
</html>