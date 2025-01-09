function updatePoster(selectElement) {
    var posterUrl = selectElement.options[selectElement.selectedIndex].getAttribute('data-poster');
    var posterContainer = document.getElementById('moviePoster');
    var posterImage = document.getElementById('posterImage');
    
    if (posterUrl && posterUrl !== '') {
        posterContainer.style.display = 'flex';
        posterImage.src = posterUrl;
    } else {
        posterContainer.style.display = 'none';
    }
}

function validateForm() {
    var jumlah = document.getElementById('jumlah').value;
    var selectedSeats = document.getElementById('selected_seats').value;
    
    if (jumlah <= 0 || jumlah > 8) {
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: 'Jumlah tiket harus antara 1-8'
        });
        return false;
    }
    
    if (!selectedSeats) {
        Swal.fire({
            icon: 'warning',
            title: 'Perhatian',
            text: 'Silakan pilih kursi terlebih dahulu'
        });
        return false;
    }
    
    var seats = selectedSeats.split(',');
    if (seats.length != jumlah) {
        Swal.fire({
            icon: 'warning',
            title: 'Perhatian',
            text: 'Jumlah kursi yang dipilih harus sama dengan jumlah tiket'
        });
        return false;
    }

    // Konfirmasi pemesanan
    Swal.fire({
        title: 'Konfirmasi Pemesanan',
        text: 'Apakah Anda yakin ingin memesan tiket ini?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Ya, Pesan!',
        cancelButtonText: 'Batal',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            document.querySelector('.booking-form').submit();
        }
    });
    
    return false;
}

function hitungTotal() {
    var jumlah = document.getElementById('jumlah').value;
    var harga = document.getElementById('harga').value;
    var total = jumlah * harga;
    document.getElementById('totalHarga').value = total;
}

function toggleSeat(seatId) {
    var seat = document.getElementById('seat-' + seatId);
    if (seat.classList.contains('booked')) {
        Swal.fire({
            icon: 'error',
            title: 'Kursi Tidak Tersedia',
            text: 'Kursi ini sudah dipesan',
            timer: 1500,
            showConfirmButton: false
        });
        return;
    }
    
    var selectedSeats = document.getElementById('selected_seats').value;
    var seatArray = selectedSeats ? selectedSeats.split(',') : [];
    var jumlah = parseInt(document.getElementById('jumlah').value);
    
    if (seat.classList.contains('selected')) {
        seat.classList.remove('selected');
        seatArray = seatArray.filter(s => s !== seatId);
    } else {
        if (seatArray.length < jumlah) {
            seat.classList.add('selected');
            seatArray.push(seatId);
        } else {
            Swal.fire({
                icon: 'warning',
                title: 'Batas Maksimum',
                text: 'Anda telah memilih maksimum kursi sesuai jumlah tiket',
                timer: 2000,
                showConfirmButton: false
            });
            return;
        }
    }
    
    document.getElementById('selected_seats').value = seatArray.join(',');
    document.getElementById('selected_seats_display').innerText =
        seatArray.length > 0 ? 'Kursi dipilih: ' + seatArray.join(', ') : 'Belum memilih kursi';
}

function decrease() {
    const jumlah = document.getElementById('jumlah');
    if (jumlah.value > 1) {
        jumlah.value = parseInt(jumlah.value) - 1;
        hitungTotal();
    }
}

function increase() {
    const jumlah = document.getElementById('jumlah');
    if (parseInt(jumlah.value || 0) < 8) {
        jumlah.value = parseInt(jumlah.value || 0) + 1;
        hitungTotal();
    }
}

function validateInput(input) {
    var value = parseInt(input.value);
    if (value < 1)
        input.value = 1;
    if (value > 8)
        input.value = 8;
    hitungTotal();
}

function confirmDelete(idTiket) {
    Swal.fire({
        title: 'Konfirmasi Hapus',
        text: 'Apakah Anda yakin ingin menghapus tiket ini?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Ya, Hapus!',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'TicketServlet';
            
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            
            var idTicketInput = document.createElement('input');
            idTicketInput.type = 'hidden';
            idTicketInput.name = 'id_tiket';
            idTicketInput.value = idTiket;
            
            form.appendChild(actionInput);
            form.appendChild(idTicketInput);
            document.body.appendChild(form);
            form.submit();
        }
    });
}

// Calculate initial total when page loads
window.onload = function() {
    hitungTotal();
};