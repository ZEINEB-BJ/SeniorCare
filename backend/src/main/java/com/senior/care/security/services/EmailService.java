package com.senior.care.security.services;



import com.senior.care.models.User;
import com.senior.care.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.UUID;


@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    UserRepository userRepository;
    @Autowired
    PasswordEncoder encoder;

    public void sendSimpleEmail(String to) {
       User user =userRepository.findByEmail(to);
        UUID uid = UUID.randomUUID();
       String newPaswword=uid.toString();
        String hashedPassword = encoder.encode(newPaswword);

        user.setPassword(hashedPassword);
       userRepository.save(user);
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("careseniore@gmail.com"); // Replace with your email or use dynamic from
        message.setTo(to); // Recipient email address
        message.setSubject("Récupération mot de passe "); // Subject of the email
        message.setText("Votre mot de passe est : \n "+newPaswword); // Email body text

        // Sending the email
        mailSender.send(message);
    }

}