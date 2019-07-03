import React from 'react';
import SessionForm from './session_form';
import { connect } from 'react-redux';
import { logIn } from '../../actions/session_actions';
import { openModal, closeModal } from '../../actions/modal_actions';

const msp = (state, ownProps) => {
  return ({
    errors: state.errors.session,
    formType: 'Log in'
  });
};

const mdp = dispatch => {
  return ({
    processForm: user => dispatch(logIn(user)),
    otherForm: (
      <button 
        onClick={() => dispatch(openModal('signup'))}>
        Sign up
      </button>
    ),
    closeModal: () => dispatch(closeModal())
  });
};

export default connect(msp, mdp)(SessionForm);