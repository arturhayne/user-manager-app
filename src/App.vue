<script setup>
import { ref, reactive, onMounted, watch } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert';

const populations = ref([]);
const selectedPopulation = ref(null);
const populationFields = ref([]);
const formData = reactive({
  user_name: '',
  password: ''
});

const fetchPopulations = async () => {
  try {
    const response = await axios.get('http://localhost:8070/population');
    populations.value = response.data;
  } catch (error) {
    Swal('Error', 'Error fetching populations.', 'error');
  }
};

const resetFormData = () => {
  formData.user_name = '';
  formData.password = '';
  populationFields.value.forEach(field => {
    formData[field.name] = '';
  });
};

const submitUser = async () => {
  if (!selectedPopulation.value) {
    Swal('Error', 'Please select a population.', 'error');
    return;
  }

  try {
    const response = await axios.post(`http://localhost:8070/population/${selectedPopulation.value.id}/user`, formData);

    if (response.status === 200) {
      Swal('Success', 'User submitted successfully.', 'success');
      resetFormData(); 
    } else {
      Swal('Error', 'Unknown error occurred.', 'error');
    }
  } catch (error) {
    if (error.response && error.response.status === 400) {
      let errorMessage = error.response.data.error;
      if(typeof errorMessage === 'object' ) {
        console.log(errorMessage)
        errorMessage = getErrorMessages(errorMessage);
      }
      Swal('Error', errorMessage, 'error');
    } else {
      Swal('Error', 'An unexpected error occurred.', 'error');
    }
  }
};

const getErrorMessages = (errorObj) => {
  let messages = [];
  for (const key in errorObj) {
    if (errorObj[key] && typeof errorObj[key] === 'object') {
      for (const subKey in errorObj[key]) {
        messages.push(errorObj[key][subKey]);
      }
    }
  }
  return messages.join('\n');
};

watch(selectedPopulation, (newPopulation) => {
  if (newPopulation) {
    populationFields.value = newPopulation.fields;
    resetFormData();
  }
});

onMounted(() => {
  fetchPopulations();
});
</script>

<template>
  <main>
    <h1>User Manager</h1>
    <select v-model="selectedPopulation">
      <option disabled value="">Select a population</option>
      <option v-for="population in populations" :key="population.id" :value="population">
        {{ population.name }}
      </option>
    </select>

    <form @submit.prevent="submitUser">
      <div>
        <label for="userName">Username:</label>
        <input type="text" id="userName" v-model="formData.user_name" required />
      </div>
      <div>
        <label for="password">Password:</label>
        <input type="password" id="password" v-model="formData.password" required />
      </div>

      <div v-for="field in populationFields" :key="field.name">
        <label :for="field.name">{{ field.displayName }}:</label>
        <input
          v-if="field.type === 'text' || field.type === 'email'"
          :type="field.type"
          :id="field.name"
          v-model="formData[field.name]"
          :required="field.required"
        />
        <input
          v-if="field.type === 'date'"
          type="date"
          :id="field.name"
          v-model="formData[field.name]"
          :required="field.required"
        />
      </div>

      <button type="submit" :disabled="!selectedPopulation">Submit</button>
    </form>
  </main>
</template>

<style scoped>
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
  width: 50%;
  box-sizing: border-box;
}

button {
  padding: 10px 20px;
  font-size: 16px;
}
</style>
