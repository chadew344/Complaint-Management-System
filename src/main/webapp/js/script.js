$(document).ready(function () {
    $("#profileDropdown").click(function (e) {
        e.stopPropagation();
        $("#dropdownMenu").toggleClass("show");
    });

    $(document).click(function () {
        $("#dropdownMenu").removeClass("show");
    });

    $(".sidebar-toggle").click(function () {
        $(".sidebar").toggleClass("show expanded");
    });

    $(document).click(function (e) {
        if ($(window).width() <= 992) {
            if (
                !$(e.target).closest(".sidebar").length &&
                !$(e.target).closest(".sidebar-toggle").length
            ) {
                $(".sidebar").removeClass("show");
            }
        }
    });

    $(".sidebar").click(function (e) {
        e.stopPropagation();
    });

    $(".nav-link").click(function () {
        $(".nav-link").removeClass("active");
        $(this).addClass("active");
    });

    $('.date-cell').each(function() {
        const rawDate = $(this).text();
        if (rawDate) {
            const formattedDate = rawDate.replace('T', ' ').replace(/\..+/, '');
            $(this).text(formattedDate);
        }
    });

    // $(".table tbody tr").click(function (e) {
    //     if (!$(e.target).closest("td:last-child").length) {
    //         console.log(
    //             "View complaint details for:",
    //             $(this).find("td:first").text()
    //         );
    //     }
    // });

    $(".toggle-password").click(function () {
        const input = $(this).siblings("input");
        const icon = $(this).find("i");
        const type = input.attr("type") === "password" ? "text" : "password";
        input.attr("type", type);
        icon.toggleClass("bi-eye bi-eye-slash");
    });

    $("#newPassword").on("input", function () {
        const password = $(this).val();
        const strength = checkPasswordStrength(password);
        const progressBar = $(this).closest(".mb-3").find(".progress-bar");
        const strengthText = $(this)
            .closest(".mb-3")
            .find(".password-strength-text");

        progressBar.css("width", strength.percentage + "%");
        progressBar
            .removeClass("bg-danger bg-warning bg-success")
            .addClass(strength.class);
        strengthText.text("Password strength: " + strength.text);
    });

    $("#confirmPassword").on("input", function () {
        const newPassword = $("#newPassword").val();
        const confirmPassword = $(this).val();

        if (
            newPassword &&
            confirmPassword &&
            newPassword !== confirmPassword
        ) {
            $(this).addClass("is-invalid");
            $("#passwordMatchError").show();
            $("#savePasswordBtn").prop("disabled", true);
        } else {
            $(this).removeClass("is-invalid");
            $("#passwordMatchError").hide();
            $("#savePasswordBtn").prop("disabled", false);
        }
    });

    $("#savePasswordBtn").click(function () {
        alert("Password changed successfully!");
        $("#passwordChangeModal").modal("hide");
        $("#passwordChangeForm")[0].reset();
    });

    function checkPasswordStrength(password) {
        let strength = 0;
        if (password.length > 0) strength++;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;

        let result = { percentage: 20 * strength };
        if (strength < 2) {
            result.class = "bg-danger";
            result.text = "weak";
        } else if (strength < 4) {
            result.class = "bg-warning";
            result.text = "medium";
        } else {
            result.class = "bg-success";
            result.text = "strong";
        }
        return result;
    }

    $("#confirmLogout").click(function () {
        window.location.href = "logout.jsp";
    });

    $(document).on('click', '.view-btn', function() {
        const complaintId = $(this).data('id');
        console.log('View clicked:', complaintId);
        $('#complaintModal iframe').attr('src', 'complaint?action=view&id=' + complaintId);
    });

    $(document).on('click', '.edit-btn', function() {
        const complaintId = $(this).data('id');
        console.log('Edit clicked:', complaintId);
        $('#complaintModal iframe').attr('src', 'complaint?action=edit&id=' + complaintId);
    });

    $(document).on('click', '.delete-btn', function() {
        const complaintId = $(this).data('id');
        console.log('Delete clicked:', complaintId);
        if(confirm('Are you sure you want to delete this complaint?')) {
            window.location.href = 'complaint?action=delete&id=' + complaintId;
        }
    });

    $('#complaintModal').on('hidden.bs.modal', function() {
        $('#complaintModal iframe').attr('src', 'pages/complaint.jsp');
    });
});

function loadComplaintModal(id, action) {
    const frame = $('#complaintFrame');
    const url = 'complaint?action=' + action + '&id=' + id;

    frame.attr('src', 'about:blank');
    frame.on('load', function() {
        this.style.height = this.contentWindow.document.body.scrollHeight + 'px';
    });

    frame.attr('src', url);

    $('#complaintModal').modal('show');
}


// $(document).on('click', '.view-btn', function() {
//     const complaintId = $(this).data('id');
//     console.log('View clicked:', complaintId);
//     loadComplaintModal(complaintId, 'view');
// });

// $(document).on('click', '.edit-btn', function() {
//     const complaintId = $(this).data('id');
//     console.log('Edit clicked:', complaintId);
//     loadComplaintModal(complaintId, 'edit');
// });
