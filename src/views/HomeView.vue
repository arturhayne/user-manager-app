<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert';

const populations = ref([]);
const selectedPopulation = ref(null);
const userName = ref('');
const password = ref('');

const fetchPopulations = async () => {
  try {
    const response = await axios.get('http://localhost:8070/population');
    populations.value = response.data;
  } catch (error) {
    console.error('Error fetching populations:', error);
    Swal('Error', 'Error fetching populations.', 'error');
  }
};

const submitUser = async () => {
  if (!selectedPopulation.value) {
    Swal('Error', 'Please select a population.', 'error');
    return;
  }

  try {
    const response = await axios.post(`http://localhost:8070/population/${selectedPopulation.value}/user`, {
      user_name: userName.value,
      password: password.value
    });

    if (response.status === 200) {
      Swal('Success', 'User submitted successfully.', 'success');
    } else {
      Swal('Error', 'Unknown error occurred.', 'error');
    }
  } catch (error) {
    if (error.response && error.response.status === 400) {
      const errorMessage = error.response.data.error;
      Swal('Error', errorMessage, 'error');
    } else {
      Swal('Error', 'An unexpected error occurred.', 'error');
    }
  }
};

onMounted(() => {
  fetchPopulations();
});
</script>

<template>
  <main>
    <h1>Home</h1>
    <select v-model="selectedPopulation">
      <option disabled value="">Select a population</option>
      <option v-for="population in populations" :key="population.id" :value="population.id">
        {{ population.name }}
      </option>
    </select>

    <form @submit.prevent="submitUser">
      <div>
        <label for="userName">Name:</label>
        <input type="text" id="userName" v-model="userName" required />
      </div>
      <div>
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="password" required />
      </div>
      <button type="submit">Submit</button>
    </form>
  </main>
</template>

<style scoped>
/* Add your styles here */
form {
  margin-top: 20px;
}

div {
  margin-bottom: 10px;
}

label {
  display: block;
  margin-bottom: 5px;
}

input {
  padding: 8px;
  width: 100%;
  box-sizing: border-box;
}

button {
  padding: 10px 20px;
  font-size: 16px;
}
</style>
