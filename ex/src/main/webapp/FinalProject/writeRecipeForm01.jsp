<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>레시피 쓰기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        input[type="text"], textarea, input[type="file"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            resize: vertical;
        }
        input[type="submit"], button[type="button"], button[type="button"] {
            background-color: #0073e6;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        input[type="submit"]:hover, button[type="button"]:hover, button[type="button"]:hover {
            background-color: #005bb5;
        }
        .add-button {
            text-align: right;
            margin: 10px 0;
        }
        .hidden {
            display: none;
        }
    </style>
    <script>
        function validateForm() {
            let ingredientNames = document.getElementsByName("ingredientName");
            let quantities = document.getElementsByName("quantity");
            for (let i = 0; i < ingredientNames.length; i++) {
                if (ingredientNames[i].value && !quantities[i].value) {
                    alert("재료에 대한 양을 입력하세요.");
                    return false;
                }
            }
            return true;
        }

        function goToMain() {
            window.location.href = 'Main.jsp';
        }

        let ingredientCount = 1;

        function addIngredient() {
            if (ingredientCount < 10) {
                ingredientCount++;
                const table = document.getElementById("ingredientTable");
                const row = table.insertRow(-1);
                const cell1 = row.insertCell(0);
                const cell2 = row.insertCell(1);
                const cell3 = row.insertCell(2);
                const cell4 = row.insertCell(3);

                cell1.innerHTML = `재료 ${ingredientCount}`;
                cell2.innerHTML = `<input type="text" name="ingredientName">`;
                cell3.innerHTML = `양 ${ingredientCount}`;
                cell4.innerHTML = `<input type="text" name="quantity">`;

                if (ingredientCount === 10) {
                    document.getElementById("addButton").classList.add("hidden");
                }
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>레시피 쓰기</h2>
        <form method="post" action="writeRecipeForm02.jsp" onsubmit="return validateForm()" enctype="multipart/form-data">
            <table id="ingredientTable">
                <tr>
                    <td>음식 이미지</td>
                    <td colspan="3"><input type="file" name="file"></td>
                </tr>
                <tr>
                    <td>음식 이름</td>
                    <td colspan="3"><input type="text" name="foodName" required></td>
                </tr>
                <tr>
                    <td>제목</td>
                    <td colspan="3"><input type="text" name="title" required></td>
                </tr>
                <tr>
                    <td>재료</td>
                    <td><input type="text" name="ingredientName" required></td>
                    <td>양</td>
                    <td><input type="text" name="quantity" required></td>
                </tr>
            </table>
            <div class="add-button">
                <button type="button" id="addButton" onclick="addIngredient()">+</button>
            </div>
            <table>
                <tr>
                    <td>내용</td>
                    <td colspan="3"><textarea name="description" rows="10" required></textarea></td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center;">
                        <input type="submit" value="전송">
                        <button type="button" onclick="goToMain()">취소</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
