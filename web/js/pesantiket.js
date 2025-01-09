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
        alert('Jumlah tiket harus antara 1-8');
        return false;
    }

    if (!selectedSeats) {
        alert('Silakan pilih kursi terlebih dahulu');
        return false;
    }

    var seats = selectedSeats.split(',');
    if (seats.length != jumlah) {
        alert('Jumlah kursi yang dipilih harus sama dengan jumlah tiket');
        return false;
    }

    return true;
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
            alert('Anda telah memilih maksimum kursi sesuai jumlah tiket');
            return;
        }
    }

    document.getElementById('selected_seats').value = seatArray.join(',');
    document.getElementById('selected_seats_display').innerText =
            seatArray.length > 0 ? 'Kursi dipilih: ' + seatArray.join(', ') : 'Belum memilih kursi';
}

function increase() {
    var input = document.getElementById('jumlah');
    var value = parseInt(input.value);
    if (value < 8) {
        input.value = value + 1;
        hitungTotal();
    }
}

function decrease() {
    var input = document.getElementById('jumlah');
    var value = parseInt(input.value);
    if (value > 1) {
        input.value = value - 1;
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

// Calculate initial total when page loads
window.onload = function () {
    hitungTotal();
};
