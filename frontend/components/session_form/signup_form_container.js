import React from 'react';
import SessionForm from './session_form';
import { connect } from 'react-redux';
import { signUp, logIn, clearErrors, updateUserProfile, createProfile } from '../../actions/session_actions';
import { openModal, closeModal } from '../../actions/modal_actions';
class UserProfileForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      first_name: '',
      last_name: '',
      date_of_birth: '',
      profile_picture: null
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handleSubmit(e) {
    e.preventDefault();
    const formData = new FormData();
    formData.append('user_profile[first_name]', this.state.first_name);
    formData.append('user_profile[last_name]', this.state.last_name);
    formData.append('user_profile[date_of_birth]', this.state.date_of_birth);
    if (this.state.profile_picture) {
      formData.append('user_profile[profile_picture]', this.state.profile_picture);
    }
    this.props.handleProfileUpdate(formData);
  }
  update(field) {
    return e => this.setState({
      [field]: e.currentTarget.value
    });
  }
  handleFile(e) {
    this.setState({ profile_picture: e.currentTarget.files[0] });
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input type="text"
          value={this.state.first_name}
          onChange={this.update('first_name')}
          placeholder="First Name"
        />
        <input type="text"
          value={this.state.last_name}
          onChange={this.update('last_name')}
          placeholder="Last Name"
        />
        <input type="date"
          value={this.state.date_of_birth}
          onChange={this.update('date_of_birth')}
        />
        <input type="file"
          onChange={this.handleFile.bind(this)}
        />
        <input type="submit" value="Update Profile" />
      </form>
    );
  }
}
const msp = (state, ownProps) => {
  return ({
    errors: state.errors.session,
    formType: 'Sign up'
  });
};
const mdp = dispatch => {
  return ({
    processForm: user => dispatch(signUp(user)),
    processDemoForm: user => dispatch(logIn(user)),
    handleProfileUpdate: profileData => dispatch(updateUserProfile(profileData)),
    handleProfileCreation: profileData => dispatch(createProfile(profileData))
      .then(profile => {
        if (profile.error) {
          alert(profile.error);
        } else {
          dispatch(updateUserProfile(profile));
        }
      }),
    otherForm: (
      <a 
        href="#"
        className="modal__btn-other-form"
        onClick={() => dispatch(openModal('login'))}>
        Log in
      </a>
    ),
    closeModal: () => dispatch(closeModal()),
    clearErrors: () => dispatch(clearErrors()),
  });
};
export default connect(msp, mdp)(UserProfileForm);
