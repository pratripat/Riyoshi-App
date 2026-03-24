const express = require('express');
const app = express();
const PORT = 8000;

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Backend is running!');
});

app.get('/dashboard', (req, res) => {
    const data = {
        'shopName': 'Royal Cuts Salon',
        'revenue': 6200,
        'customersToday': 14,
        'upcomingCount': 3,
        'revenueChange': 18,
        'appointments': [
            {
                'name': 'Anshika Sinha',
                'service': 'Hair Spa',
                'barber': 'Vikram',
                'time': '10:30',
                'duration': '60 min',
            },
            {
                'name': 'Suresh Reddy',
                'service': 'Haircut',
                'barber': 'Ravi',
                'time': '11:00',
                'duration': '30 min',
            },
            {
                'name': 'Amir Khan',
                'service': 'Beard Trim',
                'barber': 'Vikram',
                'time': '11:45',
                'duration': '20 min',
            },
        ],
    }
    res.send(data);
})

app.listen(PORT, () => {
    console.log(`Server is live at http://localhost:${PORT}`);
});