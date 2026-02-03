package com.example.digital_assets.modules.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyOtpRequest {

    @NotBlank
    private String email;

    @NotBlank
    private String inputCode;

}
